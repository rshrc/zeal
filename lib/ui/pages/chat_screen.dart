import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String uid, username;

  ChatScreen({this.uid, this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Name"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemBuilder: (context, index) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
