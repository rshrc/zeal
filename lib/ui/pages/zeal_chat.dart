import 'package:flutter/material.dart';

class ZealChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatListScreen(),
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

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
      onTap: (){

      },
    );
  }
}
