import 'package:flutter/material.dart';

import '../data/auth.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function onPressed;
  GoogleSignInButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MaterialButton(
        onPressed: () => signIn(onPressed),
        color: Colors.white,
        elevation: 0.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/glogo.png",
              height: 25.0,
              width: 25.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                "Sign in with Google",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
