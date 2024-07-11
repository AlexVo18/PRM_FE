import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BillingDetail {
  final int billingId;
  final int id;
  final int legoId;
  final int quantity;

  BillingDetail({
    required this.billingId,
    required this.id,
    required this.legoId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'BillingId': billingId,
      'Id': id,
      'LegoId': legoId,
      'Quantity': quantity,
    };
  }

  factory BillingDetail.fromJson(Map<String, dynamic> json) {
    return BillingDetail(
      billingId: json['BillingId'] ?? 0,
      id: json['Id'] ?? 0,
      legoId: json['LegoId'] ?? 0,
      quantity: json['Quantity'] ?? 0,
    );
  }

  static Future<void> saveBillingDetail(BillingDetail billingDetail) async {
    final prefs = await SharedPreferences.getInstance();
    final json = billingDetail.toMap();
    await prefs.setString('billing_detail_${billingDetail.id}', jsonEncode(json));
    print('BillingDetail saved');
  }

  static Future<BillingDetail?> getBillingDetail(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('billing_detail_$id');
    if (jsonStr == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return BillingDetail.fromJson(json);
  }
}
