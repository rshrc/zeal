import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future signIn(Function action) async {
  GoogleSignInAccount gSI = await googleSignIn.signIn();
  GoogleSignInAuthentication gSA = await gSI.authentication;
  _auth
      .signInWithGoogle(idToken: gSA.idToken, accessToken: gSA.accessToken)
      .then((user) {
    action();
  });
}
