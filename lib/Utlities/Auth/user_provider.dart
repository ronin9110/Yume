import 'package:flutter/material.dart';
import 'package:yume/Utlities/Auth/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _user =
      User(uid: "", email: "", firstname: "", lastname: "", dob: "");

  User get user => _user;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
