import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/Lego.dart';
import 'package:shop_app/models/LegoDetail.dart';

class LegoRequest {
  Future<List<Lego>> fetchLegoList() async {
    final url = Uri.parse('$baseUrl/custom/getLegoList');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> legoList = data['data'];
      print(legoList);
      return legoList.map((json) => Lego.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch lego list');
    }
  }

  Future<LegoDetail> fetchLegoDetail(int id) async {
    final url = Uri.parse('$baseUrl/custom/getLegoDetail?id_1=$id&id_2=$id');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        return LegoDetail.fromJson(data['data'][0]);
      } else {
        throw Exception('No Lego details found');
      }
    } else {
      throw Exception('Failed to fetch lego detail');
    }
  }

  Future<List<Lego>> fetchRecentLegoList() async {
    final url = Uri.parse('$baseUrl/custom/getRecentLego');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> legoList = data['data'];
      print(legoList);
      return legoList.map((json) => Lego.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch lego list');
    }
  }

  Future<List<Lego>> fetchPopularLegoList() async {
    final url = Uri.parse('$baseUrl/custom/getPopularLego');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> legoList = data['data'];
      print(legoList);
      return legoList.map((json) => Lego.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch lego list');
    }
  }

  Future<List<Lego>> fetchSearchList(String keyword) async {
    final url = Uri.parse('$baseUrl/custom/searchLegoByName?name=$keyword');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> legoList = data['data'];
      print(legoList);
      return legoList.map((json) => Lego.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch lego list');
    }
  }

  Future<List<Lego>> fetchThemedLegoList(int themeid) async {
    final url = Uri.parse('$baseUrl/custom/getLegoByThemeId?id=$themeid');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> legoList = data['data'];
      print(legoList);
      return legoList.map((json) => Lego.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch lego list');
    }
  }
}
