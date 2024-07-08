import 'package:flutter/material.dart';

class AccountResgister {
  final String email, displayName, address, phoneNumber;

  AccountResgister({
    required this.email,
    required this.displayName,
    required this.address,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'DisplayName': displayName,
      'Address': address,
      'PhoneNumber': phoneNumber,
    };
  }
}
