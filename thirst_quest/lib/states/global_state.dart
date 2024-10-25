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

  ColorScheme _colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  ColorScheme get colorScheme => _colorScheme;

  set colorScheme(ColorScheme value) {
    _colorScheme = value;
    notifyListeners();
  }
}
