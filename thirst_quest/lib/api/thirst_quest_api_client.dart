import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:thirst_quest/api/models/auth_response.dart';
import 'package:thirst_quest/api/models/review.dart';
import 'package:thirst_quest/api/models/photo.dart';
import 'package:thirst_quest/api/models/error.dart';
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

  Future<bool> createWaterBubbler(String token, WaterBubbler bubbler) async {
    final uri = Uri.parse('$baseUrl/api/waterbubblers');

    final body = json.encode({
      "name": bubbler.name,
      "description": bubbler.description,
      "latitude": bubbler.latitude,
      "longitude": bubbler.longitude,
      "favorite": bubbler.favorite,
      "upvoteCount": bubbler.upvoteCount,
      "downvoteCount": bubbler.downvoteCount,
    });

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          ..._addAuthHeader(token),
        },
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create bubbler: ${response.statusCode}, ${response.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to create bubbler: $e');
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
  // REVIEW WATER BUBBLERS
  /////////////////////////////////////////////////////////////////

  Future<bool> addReview(String token, Review review) async {
    final uri = Uri.parse('$baseUrl/api/reviews');
    try {
      final response = await http.post(
        uri,
        headers: _addAuthHeader(token, headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          "voteType": review.voteType.name,
          "waterBubblerId": review.waterBubblerId,
          "waterBubblerOsmId": review.waterBubblerOsmId
        }),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<bool> deleteReview(String token, String? bubblerId, int? bubblerOsmId) async {
    final uri = Uri.parse('$baseUrl/api/reviews');
    try {
      final response = await http.delete(
        uri,
        headers: _addAuthHeader(token, headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          'bubblerId': bubblerId,
          'openStreetId': bubblerOsmId,
        }),
      );

      return response.statusCode == 200;
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<bool> updateReview(String token, Review review) async {
    final uri = Uri.parse('$baseUrl/api/reviews');
    try {
      final response = await http.put(
        uri,
        headers: _addAuthHeader(token, headers: {'Content-Type': 'application/json'}),
        body: jsonEncode({
          "id": review.id,
          "voteType": review.voteType.name,
          "waterBubblerId": review.waterBubblerId,
          "waterBubblerOsmId": review.waterBubblerOsmId
        }),
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
    final uri = Uri.parse('$baseUrl/api/auth/extend');
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
  // Photos
  /////////////////////////////////////////////////////////////////

  Future<Photo?> uploadProfilePicture(String token, XFile pickedFile) async {
    final uri = Uri.parse('$baseUrl/api/photos/upload/profile');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_addAuthHeader(token));

      if (kIsWeb) {
        // Web - použijeme fromBytes
        final bytes = await pickedFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'profile_picture.jpg', // Libovolný název
        ));
      } else {
        // Android/iOS - zde můžeme použít fromPath (protože dart:io je k dispozici)
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          pickedFile.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Úspěch: Vrací PhotoDTO
        return Photo.fromJson(jsonDecode(response.body));
      } else {
        // Chyba: Vrací ErrorDTO
        final error = Error.fromJson(jsonDecode(response.body));
        print('Chyba při nahrávání: ${error.message}');
        return null;
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
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
