import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:thirst_quest/api/models/auth_response.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/config.dart';

class ApiClient {
  final String baseUrl = Config.apiUrl;

  ApiClient();

  Future<List<WaterBubbler>> getBubblersByBBox(
      double minLat, double maxLat, double minLon, double maxLon) async {
    final uri =
        Uri.parse('$baseUrl/api/waterbubblers').replace(queryParameters: {
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

  Future<AuthResponse?> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      return AuthResponse.fromJson(jsonDecode(response.body));
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<AuthResponse?> register(
      String email, String username, String password) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      return AuthResponse.fromJson(jsonDecode(response.body));
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<AuthResponse?> signInWithGoogle(String idToken) async {
    final uri = Uri.parse('$baseUrl/api/auth/google');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
        }),
      );

      if (response.statusCode != 200) {
        return null;
      }

      return AuthResponse.fromJson(jsonDecode(response.body));
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
}
