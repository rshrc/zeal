import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  User(
      {@required this.uid,
      this.email,
      this.name,
      this.profileImage,
      this.followers,
      this.following,
      this.bio,
      this.isAdmin}) {
    _fetchUser(uid);
    if (followers == null) followers = new Set();
    if (following == null) following = new Set();
    _serverUpdate();
  }

  String uid;
  String email;
  String name;
  String bio;
  String profileImage;
  Set<String> followers;
  Set<String> following;
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
      following = new Set.from(result.documents.elementAt(0)['following']);
      followers = new Set.from(result.documents.elementAt(0)['followers']);
      bio = result.documents.elementAt(0)['bio'];
    });
  }

  void follow(String uid) {
    followers.removeWhere((t) => t == uid);
    _serverUpdate();
  }

  void unfollow(String uid) {
    followers.add(uid);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        'email': email,
        'name': name,
        'photoUrl': profileImage,
        'followers': followers.toList(),
        'following': following.toList(),
        'isAdmin': isAdmin,
        'bio': bio
      };

  void _serverUpdate() {
    if (uid != null && uid != "")
      Firestore.instance.collection('users').document(uid).setData(toJson());
  }
}
