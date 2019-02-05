import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  User(
      {@required this.uid,
      this.email,
      this.name,
      this.profileImage,
      this.friends,
      this.isAdmin}) {
    _fetchUser(uid);
    if (friends == null) friends = new Set();
    _serverUpdate();
  }

  String uid;
  String email;
  String name;
  String profileImage;
  Set<String> friends;
  bool isAdmin = false;

  void _fetchUser(String uid) {
    Firestore.instance
        .collection('users')
        .where('id', isEqualTo: uid)
        .getDocuments()
        .then((result) {
      if (result.documents.length == 0) return;
      name = result.documents.elementAt(0)['name'];
      email = result.documents.elementAt(0)['email'];
      profileImage = result.documents.elementAt(0)['photoUrl'];
      isAdmin = result.documents.elementAt(0)['isAdmin'];
      friends = new Set.from(result.documents.elementAt(0)['friends']);
    });
  }

  void delFriend(String uid) {
    friends.removeWhere((t) => t == uid);
    _serverUpdate();
  }

  void addFriend(String uid) {
    friends.add(uid);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        'email': email,
        'name': name,
        'photoUrl': profileImage,
        'friends': friends.toList(),
        'isAdmin': isAdmin
      };

  void _serverUpdate() {
    if (uid != null && uid != "")
      Firestore.instance.collection('users').document(uid).setData(toJson());
  }
}
