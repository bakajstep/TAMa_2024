import 'package:flutter/material.dart';
import 'package:thirst_quest/states/models/identity.dart';
import 'package:thirst_quest/states/models/user.dart';

class GlobalState extends ChangeNotifier {
  final User user = User(isLoggedIn: false);

  /// This method is called when the app starts to check if the user is already logged in.
  /// If the user is logged in, the [Identity] object is passed to the [User] object.
  /// This method does not notify listeners.
  void initialLogin(Identity identity) {
    user.login(identity);
  }

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
