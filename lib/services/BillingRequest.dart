import 'dart:convert';
import 'package:shop_app/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../models/Billing.dart';
import '../models/BillingDetail.dart';

class BillingRequest {
  Future<void> saveBillingToDB(Billing billing) async {
    final url = Uri.parse('https://us-east-2.aws.neurelo.com/rest/Billing');

    final body =  jsonEncode([billing.toMap()]);

    final response = await http.post(url, headers: {'X-API-KEY': '$key'}, body: body);

    print(jsonEncode(billing.toMap()));
    if (response.statusCode == 201) {
      print('Billing saved to DB');
    } else {
      print('Failed to save billing to DB: ${response.body}');
    }
  }

  Future<void> saveBillingDetailsToDB(List<BillingDetail> billingDetails) async {
    final url = Uri.parse('https://us-east-2.aws.neurelo.com/rest/BillingDetail');

    final body = jsonEncode(billingDetails.map((detail) => detail.toMap()).toList());

    final response = await http.post(url, headers: {'X-API-KEY': '$key'}, body: body);


    print(jsonEncode(billingDetails.map((detail) => detail.toMap()).toList()));
    if (response.statusCode == 201) {
      print('Billing details saved to DB');
    } else {
      print('Failed to save billing details to DB: ${response.body}');
    }
  }

  Future<Billing> getBillingByID(int id) async {
    final url = Uri.parse('$baseUrl/rest/Billing/$id');

    final response = await http.get(url, headers: {
      'X-API-KEY': key,
      'Content-Type': 'application/json',
      'charset': 'utf-8',
    });

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['data'] != null && data['data'].isNotEmpty) {
        return Billing.fromJson(data['data']);
      } else {
        throw Exception('No Billing info found');
      }
    } else {
      throw Exception('Failed to fetch lego detail');
    }
  }
}

