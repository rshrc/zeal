import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/auth.dart';
import 'package:zeal/main.dart';
import 'package:zeal/ui/common.dart';
import 'package:zeal/ui/drawer_tabs/admin.dart';
import 'package:zeal/ui/drawer_tabs/buy_now.dart';
import 'package:zeal/ui/drawer_tabs/feed.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    updateAdmin().then((value) => setState(() {}));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Zeal",
          style: TextStyle(fontFamily: "zeal", fontSize: 30.0),
        ),
        actions: <Widget>[
          Transform.rotate(
              angle: -22 / 7 / 4.8,
              child: IconButton(onPressed: () {}, icon: Icon(Icons.send)))
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(UserData().user.profileImage)),
              accountName: new Text(UserData().user.name),
              accountEmail: new Text(UserData().user.email),
              decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: FractionalOffset.bottomLeft,
                      end: FractionalOffset.topRight,
                      colors: [
                        //Color(0xFF1a2a6c),
                        Color(0xFFfe8c00),
                        Color(0xFFf83600),
                        Color(0xFFFF0000)
                      ])),
            ),
            ListTile(
              leading: Icon(Icons.rss_feed),
              title: Text('Feed'),
              onTap: () {
                setState(() {
                  _page = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Register!'),
              onTap: () {
                setState(() {
                  _page = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  UserData().isAdmin = false;
                });
                logoutUser().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  }), (Route<dynamic> route) => false);
                });
              },
            ),
            Divider(),
            UserData().isAdmin
                ? ListTile(
                    leading: Icon(Icons.person, color: Colors.red),
                    title: Text(
                      'Admin',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      setState(() {
                        _page = 2;
                      });
                      Navigator.pop(context);
                    },
                  )
                : Container(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                popupMenuBuilder(context, AboutAppDialog(), dismiss: true);
              },
            ),
          ],
        ),
      ),
      body: Container(
          //margin: MediaQuery.of(context).padding,
          child: _page == 0
              ? Feed()
              : _page == 1 ? BuyNow() : _page == 2 ? Admin() : Container()),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.create),
//          onPressed: () => Navigator.of(context)
//              .push(MaterialPageRoute(builder: (context) => NewPost()))),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(currentIndex: 1, items: [
        BottomNavigationBarItem(
            title: Text("Home"),
            icon: IconButton(
              icon: Icon(Icons.home, color: Theme.of(context).accentColor),
              onPressed: () {},
            )),
        BottomNavigationBarItem(
            title: Text("People"),
            icon: IconButton(
              icon: Icon(Icons.group, color: Theme.of(context).accentColor),
              onPressed: () {},
            )),
        BottomNavigationBarItem(
            title: Text("New Post"),
            icon: IconButton(
              icon: Icon(Icons.add_circle_outline,
                  color: Theme.of(context).accentColor),
              onPressed: () {},
            )),
        BottomNavigationBarItem(
            title: Text("Notification"),
            icon: IconButton(
              icon: Icon(Icons.notifications,
                  color: Theme.of(context).accentColor),
              onPressed: () {},
            )),
        BottomNavigationBarItem(
            title: Text("Profile"),
            icon: IconButton(
              icon: Icon(Icons.person, color: Theme.of(context).accentColor),
              onPressed: () {},
            ))
      ]),
    );
  }
}

class AboutAppDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("About"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/logo.png'),
          Text("Insert some info here"),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Made with ",
                    style: TextStyle(fontWeight: FontWeight.w300)),
                Icon(Icons.favorite, color: Colors.red),
                Text(" by ", style: TextStyle(fontWeight: FontWeight.w300)),
                Text("Kshitij Gupta",
                    style: TextStyle(fontWeight: FontWeight.w400))
              ],
            ),
          )
        ],
      ),
    );
  }
}
