import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Account {
  final String email, displayName, address, phoneNumber, profilePicUrl;

  Account({
    required this.email,
    required this.displayName,
    required this.address,
    required this.phoneNumber,
    required this.profilePicUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'DisplayName': displayName,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'ProfilePicUrl': profilePicUrl,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      email: json['Email'] ?? '',
      displayName: json['DisplayName'] ?? '',
      address: json['Address'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      profilePicUrl: json['ProfilePicUrl'] ?? '',
    );
  }

  static Future<void> saveUser(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    final json = account.toMap(); // Assuming you have a toJson() method
    await prefs.setString('account', jsonEncode(json));
    print('User saved');
  }

  static Future<Account?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('account');
    if (jsonStr == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return Account.fromJson(json); // Assuming you have a fromJson() constructor
  }
}
