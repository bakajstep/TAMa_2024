import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thirst_quest/api/models/water_bubbler.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<List<WaterBubbler>> getBubblersByBBox(
      double minLat, double maxLat, double minLon, double maxLon) async {
    final uri = Uri.parse('$baseUrl/api/waterbubblers');
    uri.queryParameters.addAll({
      'minLat': minLat.toString(),
      'maxLat': maxLat.toString(),
      'minLon': minLon.toString(),
      'maxLon': maxLon.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load bubblers');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => WaterBubbler.fromJson(item)).toList();
  }
}
