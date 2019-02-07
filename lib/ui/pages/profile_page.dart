import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/user.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({@required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSelfProfile = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        isSelfProfile = widget.user.uid == UserData().user.uid;
        initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: (){
        // TODO
      },
      color: Colors.white,

      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          //radius: 48.0,
                          borderRadius: BorderRadius.circular(48.0),
                          //backgroundImage: CachedNetworkImageProvider(
                          //UserData().user.profileImage),
                          child: CachedNetworkImage(
                              imageUrl: UserData().user.profileImage,
                              placeholder: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          0.toString(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Posts",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          widget.user.following.length.toString(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Following",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          widget.user.followers.length.toString(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ButtonTheme(
                                // So that we can customize the button later
                                minWidth: 200,
                                child: RaisedButton(
                                  //color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed("/edit_profile");
                                  },
                                  child: Text("Edit Profile"),
                                  color: Theme.of(context).primaryColor,
                                  /*shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),*/
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    UserData().user.name,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: widget.user.bio == ""
                      ? Text(
                          "This user hasn't provided a bio",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : Text(widget.user.bio),
                )
              ],
            ),
            Expanded(
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this would produce 2 rows.
                crossAxisCount: 3,
                // Generate 100 Widgets that display their index in the List
                children: List.generate(100, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/profile");
                    },
                    child: Container(
                      child: Image.asset(
                        "assets/dog_image.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
