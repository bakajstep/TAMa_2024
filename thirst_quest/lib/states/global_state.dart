import 'package:flutter/material.dart';
import 'package:thirst_quest/states/models/identity.dart';
import 'package:thirst_quest/states/models/user.dart';

class GlobalState extends ChangeNotifier {
  final User user = User(isLoggedIn: false);

  void login(Identity newIdentity) {
    user.login(newIdentity);
    notifyListeners();
  }

  void logout() {
    user.logout();
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    user.identity!.username = newUsername;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    user.identity!.email = newEmail;
    notifyListeners();
  }
}
