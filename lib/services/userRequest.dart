import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/AccountRegister.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/LegoDetail.dart';

class UserRequest {
  Future<void> createAccount(AccountResgister account) async {
    final url = Uri.parse('$baseUrl/custom/createAccount');

    final body = jsonEncode(account.toMap());

    final response =
        await http.post(url, headers: {'X-API-KEY': '$key'}, body: body);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add account');
    }
  }
}
