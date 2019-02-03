import 'package:flutter/material.dart';

class ZealChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(),
      appBar: AppBar(
        title: Text(
          "Zeal Chat",
          style: TextStyle(fontFamily: "zeal", fontSize: 32.0),
        ),
        centerTitle: true,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return getFriendTile(index);
      },
    );
  }

  Widget getFriendTile(int number) {
    return ListTile(
      leading: Icon(
        Icons.ac_unit,
        color: Colors.pinkAccent,
      ),
      title: Text("Friend $number"),
      subtitle: Text("Latest Chat"),
      trailing: Icon(
        Icons.delete_outline,
        color: Colors.purple,
      ),
    );
  }
}
