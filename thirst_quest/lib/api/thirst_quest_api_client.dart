import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:thirst_quest/api/models/auth_response.dart';
import 'package:thirst_quest/api/models/water_bubbler.dart';
import 'package:thirst_quest/config.dart';

class ThirstQuestApiClient {
  final String baseUrl = Config.thirstQuestApiUrl;

  /////////////////////////////////////////////////////////////////
  // WATER BUBBLERS
  /////////////////////////////////////////////////////////////////

  Future<List<WaterBubbler>> getBubblersByBBox(
      double minLat, double maxLat, double minLon, double maxLon, String? token) async {
    final uri = Uri.parse('$baseUrl/api/waterbubblers').replace(queryParameters: {
      'minLat': minLat.toString(),
      'maxLat': maxLat.toString(),
      'minLon': minLon.toString(),
      'maxLon': maxLon.toString(),
    });

    final headers = token != null ? _addAuthHeader(token) : null;

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to load bubblers');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => WaterBubbler.fromJson(item)).toList();
  }

  Future<List<WaterBubbler>> getWaterBubblersCreatedByUser(String token) async {
    final uri = Uri.parse('$baseUrl/api/waterbubblers/user');

    final response = await http.get(
      uri,
      headers: _addAuthHeader(token),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load bubblers');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => WaterBubbler.fromJson(item)).toList();
  }

  Future<bool> deleteWaterBubbler(String token, String bubblerId) async {
    final uri = Uri.parse('$baseUrl/api/waterbubblers');

    final body = json.encode({
      "bubblerId": bubblerId,
      "openStreetId": null,
    });

    try {
      final response = await http.delete(
        uri,
        headers: {
          "Content-Type": "application/json",
          ..._addAuthHeader(token), // Přidáme autorizační hlavičku
        },
        body: body,
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  /////////////////////////////////////////////////////////////////
  // FAVORITE WATER BUBBLERS
  /////////////////////////////////////////////////////////////////

  Future<bool> addToFavorites(String token, String? id, int? osmId) async {
    final uri = Uri.parse('$baseUrl/api/users/favorites');
    try {
      final response = await http.post(
        uri,
        headers: _addAuthHeader(token, headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          'bubblerId': id,
          'openStreetId': osmId,
        }),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<bool> removeFromFavorites(String token, String? id, int? osmId) async {
    final uri = Uri.parse('$baseUrl/api/users/favorites');
    try {
      final response = await http.delete(
        uri,
        headers: _addAuthHeader(token, headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          'bubblerId': id,
          'openStreetId': osmId,
        }),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<List<WaterBubbler>> getUsersFavoriteWaterBubblers(String token) async {
    final uri = Uri.parse('$baseUrl/api/users/favorites');

    final response = await http.get(
      uri,
      headers: _addAuthHeader(token),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load favourite bubblers');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => WaterBubbler.fromJson(item)).toList();
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

  Future<AuthResponse?> register(String email, String username, String password) async {
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

  Map<String, String> _addAuthHeader(String token, {Map<String, String>? headers}) {
    headers ??= {};
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }
}
