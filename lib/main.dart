import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/ui/pages/others_profile_page.dart';

import 'data/auth.dart';
import 'ui/buttons.dart';
import 'ui/pages/chat_screen.dart';
import 'ui/pages/home.dart';
import 'ui/pages/zeal_chat.dart';
import 'ui/pages/edit_profile.dart';

Future<void> main() async {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: MaterialColor(0xFFFFFFFF, const <int, Color>{
        50: const Color(0xFFFFFFFF),
        100: const Color(0xFFFFFFFF),
        200: const Color(0xFFFFFFFF),
        300: const Color(0xFFFFFFFF),
        400: const Color(0xFFFFFFFF),
        500: const Color(0xFFFFFFFF),
        600: const Color(0xFFFFFFFF),
        700: const Color(0xFFFFFFFF),
        800: const Color(0xFFFFFFFF),
        900: const Color(0xFFFFFFFF)
      }),
      accentColor: Colors.white,
      brightness: Brightness.dark,
    ),
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => AppWrapper(),
      '/home': (BuildContext context) => HomeScreen(),
      '/zeal_chat': (BuildContext context) => ZealChat(),
      '/chat_screen': (BuildContext context) => ChatScreen(),
      '/other_profile': (BuildContext context) => OtherProfilePage(),
      '/edit_profile': (BuildContext context) => EditProfile(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    pushAndReplace('/login');
  }

  Future<void> pushAndReplace(String routeName) async {
    // Needed for hero animation
    final current = ModalRoute.of(context);
    Navigator.pushNamed(context, routeName);
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.removeRoute(context, current);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    // Make our life a bit easier.
    AppData().scaleFactorH = MediaQuery.of(context).size.height / 900;
    AppData().scaleFactorW = MediaQuery.of(context).size.width / 450;
    AppData().scaleFactorA = (MediaQuery.of(context).size.width *
            MediaQuery.of(context).size.height) /
        (900 * 450);

    return Scaffold(
      appBar: null,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft,
                    tileMode: TileMode.clamp)),
          ),
          Center(
              child: Hero(
            tag: "logo",
            child: Container(
              height: h / 3.75,
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  @override
  AppWrapperState createState() {
    return AppWrapperState();
  }
}

class AppWrapperState extends State<AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    isLoggedIn().then((value) {
      if (value) {
        signIn(() {
          print("Sign in Successful!\nWelcome to Zeal!");
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              settings: RouteSettings(name: '/home'),
              builder: (context) => HomeScreen()));
        });
      }
    });
    var h = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Opacity(
            opacity: 0.05,
            child: Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -math.pi / 4.8,
                alignment: Alignment.center,
                child: ClipPath(
                  child: Container(
                    child: Image(
                        width: h / 2.0,
                        height: h / 2.0,
                        image: AssetImage('assets/logo.png')),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: h / 3.75,
          left: 0.0,
          right: 0.0,
          child: Hero(
              tag: "logo",
              child: Container(
                  height: h / 4.5,
                  child: Image.asset(
                    'assets/logo.png',
                  ))),
        ),
        Positioned(
          top: h / 1.85,
          left: 0.0,
          right: 0.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GoogleSignInButton(
              onPressed: () {
                print("Sign in Successful!\nWelcome to Zeal!");
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ),
        )
      ],
    );
  }
}
