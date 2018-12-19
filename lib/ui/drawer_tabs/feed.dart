import 'package:flutter/material.dart';
import 'package:funkrafte/ui/post.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: _feedColumnBuilder(),
    ));
  }

  List<Widget> _feedColumnBuilder() {
    List<Widget> ret = new List();
    ret.add(Post());
    ret.add(Post());
    return ret;
  }
}
