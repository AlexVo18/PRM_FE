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

  const BillingDetailsScreen({Key? key, required this.billing}) : super(key: key);

  Future<List<BillingDetail>> fetchBillingDetail() async {
    final billingRequest = BillingRequest();
    return billingRequest.getBillingRequestByBillingId(billing.id);
  }

  Future<LegoDetail> legoDetail(int id) async {
    final legoRequest = LegoRequest();
    LegoDetail lego = await legoRequest.fetchLegoDetail(id);
    return lego;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(billing.datePaid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $formattedDate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Total amount: \$${billing.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Email: ${billing.accountEmail}'),
            SizedBox(height: 16),
            FutureBuilder<List<BillingDetail>>(
              future: fetchBillingDetail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No billing details found.'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        BillingDetail detail = snapshot.data![index];
                        return FutureBuilder<LegoDetail>(
                          future: legoDetail(detail.legoId),
                          builder: (context, legoSnapshot) {
                            if (legoSnapshot.connectionState == ConnectionState.waiting) {
                              return ListTile(
                                title: Text('Loading...'),
                              );
                            } else if (legoSnapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${legoSnapshot.error}'),
                              );
                            } else {
                              return ListTile(
                                title: Text('Item Name: ${legoSnapshot.data!.name}'),
                                subtitle: Text('Price: ${legoSnapshot.data!.price}'),
                                trailing: Text('Quantity: ${detail.quantity}'),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
