import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app_data.dart';
import 'firebase.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> logoutUser() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
}

Future<bool> isLoggedIn() async {
  bool ret = await _googleSignIn.isSignedIn();
  ret = ret && _auth.currentUser() != null;
  return ret;
}

Future signIn(Function action) async {
  GoogleSignInAccount gSI = await _googleSignIn.signIn();
  GoogleSignInAuthentication gSA;
  try {
    gSA = await gSI.authentication;
    _auth
        .signInWithGoogle(idToken: gSA.idToken, accessToken: gSA.accessToken)
        .then((user) {
      action();
      UserData().user = user;
      updateUserDB();
    });
  } catch (e) {}
}
