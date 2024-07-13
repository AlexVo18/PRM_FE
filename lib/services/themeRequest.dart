import 'dart:convert';

import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/Theme.dart';
import 'package:shop_app/models/ThemeCount.dart';
import 'package:http/http.dart' as http;

class ThemeRequest {
  Future<List<Theme>> fetchThemeList() async {
    final url = Uri.parse('$baseUrl/custom/getThemesList');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> themeList = data['data'];
      print(themeList);
      return themeList.map((json) => Theme.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch theme list');
    }
  }

  Future<List<ThemeCount>> fetchThemeCount() async {
    final url = Uri.parse('$baseUrl/custom/getThemesCount');

    final response = await http.get(url, headers: {'X-API-KEY': '$key'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> countList = data['data'];
      print(countList);
      return countList.map((json) => ThemeCount.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch count list');
    }
  }
}
