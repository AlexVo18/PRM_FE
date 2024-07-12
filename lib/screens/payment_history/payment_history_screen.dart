import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:shop_app/services/BillingRequest.dart';
import 'package:shop_app/screens/payment_history/components/payment_history_card.dart';

class PaymentHistoryScreen extends StatelessWidget {
  //static String routeName = "/payment_history";

  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: FutureBuilder<List<Billing>>(
        future: fetchBillingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payment history found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PaymentHistoryCard(billing: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Billing>> fetchBillingHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    if (email != null) {
      final billingService = BillingRequest();
      return billingService.getBillingByEmail(email);
    } else {
      throw Exception('User email not found in preferences');
    }
  }
}
