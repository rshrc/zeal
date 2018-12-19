import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:funkrafte/data/app_data.dart';
import 'package:funkrafte/ui/drawer_tabs/feed.dart';

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
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
          margin: MediaQuery.of(context).padding,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50.0),
            child: Feed(),
          )),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.create), onPressed: () {}),
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
