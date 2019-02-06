import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/auth.dart';
import 'package:zeal/ui/drawer_tabs/feed.dart';
import 'package:zeal/ui/pages/discover_people.dart';
import 'package:zeal/ui/pages/notification_page.dart';
import 'package:zeal/ui/pages/profile_page.dart';

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
        leading: IconButton(icon: Icon(Icons.add), onPressed: () {}),
        title: Text(
          "Zeal",
          style: TextStyle(fontFamily: "zeal", fontSize: 30.0),
        ),
        actions: <Widget>[
          Transform.rotate(
            angle: -22 / 7 / 4.8,

            /// The Message Button takes you to the Chat Screen
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/zeal_chat');
              },
              icon: Icon(Icons.send),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
          //margin: MediaQuery.of(context).padding,
          /// page 0, Feed (Home Page)
          /// page 1, Discover People
          /// page 2, Notification Page
          /// page 3, Profile Page
          child: _page == 0
              ? Feed()
              : _page == 1
                  ? DiscoverPeoplePage()
                  : _page == 2
                      ? NotificationPage()
                      : _page == 3
                          ? ProfilePage(
                              user: UserData().user,
                            )
                          : Container()),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _page,
            items: [
              BottomNavigationBarItem(
                  title: Container(),
                  icon: IconButton(
                    icon: Icon(Icons.home,
                        color: _page != 0
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                    onPressed: () {
                      setState(() {
                        _page = 0;
                      });
                    },
                  )),
              BottomNavigationBarItem(
                  title: Container(),
                  icon: IconButton(
                    icon: Icon(Icons.group,
                        color: _page != 1
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                    onPressed: () {
                      _page = 1;
                    },
                  )),
              BottomNavigationBarItem(
                  title: Container(),
                  icon: IconButton(
                    icon: Icon(Icons.notifications,
                        color: _page != 2
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                    onPressed: () {
                      _page = 2;
                    },
                  )),
              BottomNavigationBarItem(
                  title: Container(),
                  icon: IconButton(
                    icon: Icon(Icons.person,
                        color: _page != 3
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                    onPressed: () {
                      setState(() {
                        _page = 3;
                      });
                    },
                  ))
            ]),
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
