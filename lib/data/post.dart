import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:funkrafte/data/app_data.dart';

class Post {
  /// Let's just avoid conflicts here :)
  String id = "${Random().nextInt(10000)}_${Random().nextInt(10000)}";
  String imageUrl;
  String caption = "";
  String uid = "";
  String currentUid = UserData().user.uid;
  int likes = 0;
  bool liked = false;
  Map<String, String> comments = new Map();
  Set<String> likedBy = new Set();
  DocumentSnapshot ds;

  Post({this.id, this.imageUrl, this.caption, this.ds, this.uid}) {
    if (ds == null)
      publishDoc();
    else
      loadFromDs();
  }

  void addComment(String comment) {
    comments[currentUid] = comment;
  }

  void like() {
    if (likedBy == null) likedBy = new HashSet();
    liked = !liked;
    // ignore: unnecessary_statements
    liked
        ? likedBy.add(currentUid)
        : likedBy.contains(currentUid) ? likedBy.remove(currentUid) : '';
    likes = likedBy.length;
    serverUpdate();
  }

  void serverUpdate() {
    Firestore.instance
        .collection('posts')
        .document(id)
        .updateData({'likedBy': likedBy.toList()});
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "imageUrl": imageUrl,
        "caption": caption,
        "likedBy": likedBy.toList(),
        "comments": comments
      };

  Future<void> publishDoc() async {
    DocumentReference ref =
        await Firestore.instance.collection('posts').add(this.toJson());
    id = ref.documentID;
    ref.updateData({'id': id});
    ds = await ref.get();
  }

  Future<void> loadFromDs() async {
    uid = ds['uid'];
    id = ds['id'];
    imageUrl = ds['imageUrl'];
    caption = ds['caption'];
    likedBy = new Set.from(ds['likedBy']);
    likes = likedBy == null ? 0 : likedBy.length;
    setLiked();
    comments = new Map.from(ds['comments']);
  }

  void setLiked() {
    if (likedBy != null && likedBy.contains(currentUid)) liked = true;
  }
}
