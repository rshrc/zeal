import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/post.dart';
import 'package:zeal/ui/post.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  int adjIndex = (snapshot.data.documents.length - 1) - index;
                  print(adjIndex.toString()+ " " + snapshot.data.documents[adjIndex]['uid'].toString());
                  if (!UserData().user.following.contains(snapshot.data.documents[adjIndex]['uid']))
                    return Container();
                  return PostWidget(
                      p: Post(ds: snapshot.data.documents[adjIndex]));
                });
        });
  }
}

class GlobalFeed extends StatefulWidget {
  @override
  _GlobalFeedState createState() => _GlobalFeedState();
}

class _GlobalFeedState extends State<GlobalFeed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('posts')
            .where('private', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  int adjIndex = (snapshot.data.documents.length - 1) - index;
                  return PostWidget(
                      p: Post(ds: snapshot.data.documents[adjIndex]));
                });
        });
  }
}
