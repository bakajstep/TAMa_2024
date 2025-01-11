import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thirst_quest/api/models/city_paginator.dart';
import 'package:thirst_quest/config.dart';

class GeoNamesApiClient {
  final String baseUrl = Config.geoNamesApiUrl;

  Future<CityPaginator> getCitiesByPrefix(String prefix) async {
    final uri = Uri.parse('$baseUrl/searchJSON').replace(queryParameters: {
      'name_startsWith': prefix,
      'username': Config.geoNamesUsername,
      'maxRows': '10',
      'countryBias': 'CZ',
      'cities': 'cities5000',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load cities');
    }

    final dynamic body = jsonDecode(response.body);
    return CityPaginator.fromJson(body);
  }
}
