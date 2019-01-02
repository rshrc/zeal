import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:funkrafte/data/app_data.dart';
import 'package:funkrafte/data/auth.dart';
import 'package:funkrafte/main.dart';
import 'package:funkrafte/ui/common.dart';
import 'package:funkrafte/ui/drawer_tabs/feed.dart';
import 'package:funkrafte/ui/new_post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(UserData().user.photoUrl)),
              accountName: new Text(UserData().user.displayName),
              accountEmail: new Text(UserData().user.email),
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.75), BlendMode.dstATop),
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                        "https://cdn.techjuice.pk/wp-content/uploads/2016/07/31.png"),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.rss_feed),
              title: Text('Feed'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Buy now!'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                logoutUser().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return SplashScreen();
                  }), (Route<dynamic> route) => false);
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                popupMenuBuilder(context, AboutAppDialog());
              },
            ),
          ],
        ),
      ),
      body: Container(
          //margin: MediaQuery.of(context).padding,
          child: Feed()),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewPost()))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }),
          ],
        ),
      ),
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
