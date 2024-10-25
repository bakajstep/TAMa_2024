import 'package:thirst_quest/states/models/identity.dart';

class User {
  bool isLoggedIn = false;
  Identity? identity;

  void login(Identity newIdentity) {
    isLoggedIn = true;
    identity = newIdentity;
  }

  void logout() {
    isLoggedIn = false;
    identity = null;
  }

  User({required this.isLoggedIn, this.identity});
}
