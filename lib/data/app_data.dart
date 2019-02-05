import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user.dart';

class UserData {
  static final UserData _singleton = new UserData._internal();

  FirebaseUser fireUser;
  User user = User(uid: "");
  bool isAdmin = false;
  String emotion;

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}

class AppData {
  static final AppData _singleton = new AppData._internal();

  double scaleFactorW = 0;
  double scaleFactorH = 0;
  double scaleFactorA = 0;

  factory AppData() {
    return _singleton;
  }
  AppData._internal();
}

class GlobalColorScheme {
  Color iconColor = Colors.pink;
  static final GlobalColorScheme _singleton = new GlobalColorScheme._internal();

  factory GlobalColorScheme() {
    return _singleton;
  }

  GlobalColorScheme._internal();
}
