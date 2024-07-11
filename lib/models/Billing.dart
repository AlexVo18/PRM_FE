import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Billing {
  final String accountEmail;
  final DateTime dateCreated;
  final DateTime datePaid;
  final int id;
  final int status;
  final double totalPrice;

  Billing({
    required this.accountEmail,
    required this.dateCreated,
    required this.datePaid,
    required this.id,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'AccountEmail': accountEmail,
      'DateCreated': dateCreated.toIso8601String(),
      'DatePaid': datePaid.toIso8601String(),
      'Id': id,
      'Status': status,
      'TotalPrice': totalPrice,
    };
  }

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      accountEmail: json['AccountEmail'] ?? '',
      dateCreated: DateTime.parse(json['DateCreated']),
      datePaid: DateTime.parse(json['DatePaid']),
      id: json['Id'] ?? 0,
      status: json['Status'] ?? 0,
      totalPrice: json['TotalPrice']?.toDouble() ?? 0.0,
    );
  }

  static Future<void> saveBilling(Billing billing) async {
    final prefs = await SharedPreferences.getInstance();
    final json = billing.toMap();
    await prefs.setString('billing_${billing.id}', jsonEncode(json));
    print('Billing saved');
  }

  static Future<Billing?> getBilling(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('billing_$id');
    if (jsonStr == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return Billing.fromJson(json);
  }
}
