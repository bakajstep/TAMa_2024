import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirst_quest/api/api_client.dart';
import 'package:thirst_quest/api/models/auth_response.dart';
import 'package:thirst_quest/config.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/states/models/identity.dart';

class AuthService {
  static const _tokenKey = 'token';
  final ApiClient apiClient;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? Config.googleClientId : null,
    serverClientId: kIsWeb ? null : Config.googleClientId,
  );

  AuthService({required this.apiClient});

  Future<AuthResponse?> login(
      String email, String password, GlobalState globalState) async {
    final response = await apiClient.login(email, password);

    return _handleAuthResponse(response, globalState);
  }

  Future<AuthResponse?> register(String email, String username, String password,
      GlobalState globalState) async {
    final response = await apiClient.register(email, username, password);

    return _handleAuthResponse(response, globalState);
  }

  Future<AuthResponse?> signInWithGoogle(
      String idToken, GlobalState globalState) async {
    final response = await apiClient.signInWithGoogle(idToken);

    return _handleAuthResponse(response, globalState);
  }

  Future<AuthResponse?> _handleAuthResponse(
      AuthResponse? response, GlobalState globalState) async {
    if (response == null) {
      return null;
    }

    globalState.login(Identity(
      id: response.user.id,
      email: response.user.email,
      username: response.user.username,
      googleAuth: response.user.authByGoogle,
      roles: response.roles,
    ));

    final pref = await SharedPreferences.getInstance();
    await pref.setString(_tokenKey, response.token);

    return response;
  }

  Future logout(GlobalState globalState) async {
    globalState.logout();
    googleSignIn.disconnect();

    final pref = await SharedPreferences.getInstance();
    await pref.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  Future checkLoginAndExtend(GlobalState globalState) async {
    final token = await getToken();
    if (token == null) {
      return;
    }

    _handleAuthResponse(await apiClient.extend(token), globalState);
  }
}
