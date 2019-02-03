import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return getNotificationTile(index);
      },
    );
  }

  Widget getNotificationTile(int number) {
    return ListTile(
      leading: Icon(
        Icons.message,
        color: Colors.pinkAccent,
      ),
      title: Text("Notification $number"),
      subtitle: Text("notification message"),
      trailing: Icon(
        Icons.remove,
        color: Colors.blueGrey,
      ),
    );
  }
}
