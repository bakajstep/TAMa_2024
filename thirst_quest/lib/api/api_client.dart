import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:thirst_quest/api/models/auth_response.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/config.dart';

class ApiClient {
  final String baseUrl = Config.apiUrl;

  /////////////////////////////////////////////////////////////////
  // WATER BUBBLERS
  /////////////////////////////////////////////////////////////////

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

  /////////////////////////////////////////////////////////////////
  // FAVORITE WATER BUBBLERS
  /////////////////////////////////////////////////////////////////

  Future<bool> addToFavorites(String token, String? id, int? osmId) async {
    final uri = Uri.parse('$baseUrl/api/favorites');
    try {
      final response = await http.post(
        uri,
        headers: _addAuthHeader(token,
            headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          'id': id,
          'osmId': osmId,
        }),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<bool> removeFromFavorites(String token, String id) async {
    final uri = Uri.parse('$baseUrl/api/favorites/$id');
    try {
      final response = await http.delete(
        uri,
        headers: _addAuthHeader(token),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  /////////////////////////////////////////////////////////////////
  // USER AUTH
  /////////////////////////////////////////////////////////////////

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

  Future<AuthResponse?> extend(String token) async {
    final uri = Uri.parse('$baseUrl/api/auth/google');
    try {
      final response = await http.post(
        uri,
        headers: _addAuthHeader(token),
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

  /////////////////////////////////////////////////////////////////
  // HELPERS
  /////////////////////////////////////////////////////////////////

  Map<String, String> _addAuthHeader(String token,
      {Map<String, String>? headers}) {
    headers ??= {};
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }
}
