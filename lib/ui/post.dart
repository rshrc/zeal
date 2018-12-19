import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:funkrafte/data/app_data.dart';

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserInfoRow(),
          SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Image.asset('assets/logo.png', fit: BoxFit.cover))
              ],
            ),
          ),
          PostInfoBar(),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(UserData().user.photoUrl)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              UserData().user.displayName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class PostInfoBar extends StatefulWidget {
  @override
  PostInfoBarState createState() {
    return new PostInfoBarState();
  }
}

class PostInfoBarState extends State<PostInfoBar> {
  bool like = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => setState(() {
                      like = !like;
                      if (like)
                        likeCount += 1;
                      else if (!like && likeCount > 0) likeCount -= 1;
                    }),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                  child: like
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
                child: Icon(Icons.comment),
              ),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0, bottom: 8.0),
            child: Text(
              "$likeCount likes",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0, right: 16.0, left: 16.0),
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
          ),
        ],
      ),
    );
  }
}
