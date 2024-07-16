import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:shop_app/models/BillingDetail.dart';
import 'package:shop_app/models/LegoDetail.dart';
import 'package:shop_app/services/BillingRequest.dart';
import 'package:shop_app/services/legoRequest.dart';

class BillingDetailsScreen extends StatelessWidget {
  static const String routeName = '/billing_details';

  final Billing billing;

  const BillingDetailsScreen({Key? key, required this.billing})
      : super(key: key);

  Future<Map<String, dynamic>> fetchBillingAndLegoDetails() async {
    final billingRequest = BillingRequest();
    List<BillingDetail> billingDetails =
        await billingRequest.getBillingRequestByBillingId(billing.id);

    final legoRequest = LegoRequest();
    List<LegoDetail> legoDetails = await Future.wait(
      billingDetails
          .map((detail) => legoRequest.fetchLegoDetail(detail.legoId))
          .toList(),
    );

    return {
      'billingDetails': billingDetails,
      'legoDetails': legoDetails,
    };
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(billing.datePaid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBillingAndLegoDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No billing details found.'));
          } else {
            List<BillingDetail> billingDetails =
                snapshot.data!['billingDetails'];
            List<LegoDetail> legoDetails = snapshot.data!['legoDetails'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: $formattedDate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                      'Total amount: \$${billing.totalPrice.toStringAsFixed(2)}'),
                  SizedBox(height: 8),
                  Text('Email: ${billing.accountEmail}'),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: billingDetails.length,
                      itemBuilder: (context, index) {
                        BillingDetail detail = billingDetails[index];
                        LegoDetail lego = legoDetails[index];
                        return ListTile(
                          title: Text('Item Name: ${lego.name}'),
                          subtitle: Text('Price: ${lego.price}'),
                          trailing: Text('Quantity: ${detail.quantity}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
