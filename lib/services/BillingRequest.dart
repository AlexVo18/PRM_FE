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

  Future<List<Billing>> getBillingByEmail(String email) async {
    final encodedEmail = Uri.encodeComponent(email);
    final url = Uri.parse('$baseUrl/rest/Billing?filter=%7B%0A++%22AccountEmail%22%3A+%22$encodedEmail%22%0A%7D');

    final response = await http.get(url, headers: {
      'X-API-KEY': key,
      'Content-Type': 'application/json',
      'charset': 'utf-8',
    });

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(utf8.decode(response.bodyBytes))['data'];

      if (dataList.isNotEmpty) {
        List<Billing> billings = dataList.map((item) => Billing.fromJson(item)).toList();
        return billings;
      } else {
        throw Exception('No billing info found for email: $email');
      }
    } else {
      throw Exception('Failed to fetch billing data');
    }
  }

  Future<List<BillingDetail>> getBillingRequestByBillingId(int billingId) async {
    final url = Uri.parse('$baseUrl/rest/BillingDetail?filter=%7B%0A++%22BillingId%22%3A+$billingId%0A%7D');

    final response = await http.get(url, headers: {
      'X-API-KEY': key,
      'Content-Type': 'application/json',
      'charset': 'utf-8',
    });

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(utf8.decode(response.bodyBytes))['data'];

      if (dataList.isNotEmpty) {
        List<BillingDetail> billingsDetail = dataList.map((item) => BillingDetail.fromJson(item)).toList();
        return billingsDetail;
      } else {
        throw Exception('No billing info found for billing ID: $billingId');
      }
    } else {
      throw Exception('Failed to fetch billing data');
    }
  }
}

