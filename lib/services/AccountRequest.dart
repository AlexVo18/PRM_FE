import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/Account.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/LegoDetail.dart';

class AccountRequest {
  Future<void> createAccount(Account account) async {
    final url = Uri.parse('$baseUrl/custom/createAccount');

    final body = jsonEncode(account.toMap());

    final response =
        await http.post(url, headers: {'X-API-KEY': '$key'}, body: body);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add account');
    }
  }

  Future<Account> getAccountDetail(String email) async {
    final url = Uri.parse('$baseUrl/rest/Account/$email');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        return Account.fromJson(data['data']);
      } else {
        throw Exception('No Lego details found');
      }
    } else {
      throw Exception('Failed to fetch lego detail');
    }
  }

  Future<void> uploadAvatarImage(String email, String pictureUrl) async {
    final url = Uri.parse('$baseUrl/custom/updateAccountPic');

    final body = {
      'Email': email,
      'ProfilePicUrl': pictureUrl,
    };

    final bodyEncode = jsonEncode(body);

    final response =
        await http.post(url, headers: {'X-API-KEY': '$key'}, body: bodyEncode);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add avatar');
    }
  }
}
