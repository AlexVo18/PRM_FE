import 'package:flutter/material.dart';
import 'package:shop_app/models/Billing.dart';
import 'package:intl/intl.dart';

class PaymentHistoryCard extends StatelessWidget {
  final Billing billing;

  const PaymentHistoryCard({Key? key, required this.billing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(billing.datePaid);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $formattedDate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 8),
            Text('Total amount: \$${billing.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Email: ${billing.accountEmail}'),
          ],
        ),
      ),
    );
  }
}
