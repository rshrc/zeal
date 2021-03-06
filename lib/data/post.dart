import 'dart:collection';
import 'dart:core';
import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/firebase.dart';
import 'package:zeal/ui/common.dart';

class Post {
  /// Let's just avoid conflicts here :)
  String id = "${Random().nextInt(10000)}_${Random().nextInt(10000)}";
  String imageUrl;
  String caption = "";
  String uid = "";
  String currentUid = UserData().user.uid;
  int likes = 0;
  bool liked = false;
  Map<String, List<dynamic>> comments = new Map();
  Set<String> likedBy = new Set();
  DocumentSnapshot ds;
  String _origuname = "";
  bool private = false;

  Post({this.id, this.imageUrl, this.caption, this.ds, this.uid, this.private}) {
    if (ds == null) {
      publishDoc();
    } else
      loadFromDs();
  }

  Future<void> reloadPostData() async {
    await Firestore.instance
        .collection('posts')
        .where('id', isEqualTo: this.id)
        .getDocuments()
        .then((v) {
      DocumentSnapshot _ds = v.documents[0];
      ds = _ds;
      loadFromDs();
    });
  }

  String randomStringGen() {
    return "${Random().nextInt(10000)}-${Random().nextInt(10000)}";
  }

  void addComment(String comment) {
    List<String> currentComment = new List<String>();
    currentComment.add(currentUid);
    currentComment.add(comment);
    var cKey = new DateTime.now().millisecondsSinceEpoch.toString() +
        randomStringGen();
    comments[cKey] = currentComment;
    serverUpdate();
  }

  void like() {
    if (likedBy == null) likedBy = new HashSet();
    liked = !liked;
    liked
        ? likedBy.add(currentUid)
        // ignore: unnecessary_statements
        : likedBy.contains(currentUid) ? likedBy.remove(currentUid) : '';
    likes = likedBy.length;
    serverUpdate();
  }

  void share() {
    if (UserData().user.uid != uid) {
      id = "";
      getUsername(uid).then((v) {
        _origuname = v;
        publishDoc(share: true);
      });
    }
  }

  void serverUpdate() {
    Firestore.instance
        .collection('posts')
        .document(id)
        .updateData({'likedBy': likedBy.toList(), 'comments': comments});
  }

  Map<String, dynamic> toJson({bool share = false}) => {
        "uid": share ? UserData().user.uid : uid,
        "id": id,
        "imageUrl": imageUrl,
        "caption":
            share ? "Originally posted by $_origuname\n" + caption : caption,
        "likedBy": share ? List() : likedBy.toList(),
        "comments": share ? Map() : comments,
    "private": private
      };

  Future<void> publishDoc({bool share = false}) async {
    DocumentReference ref = await Firestore.instance
        .collection('posts')
        .add(this.toJson(share: share));
    id = ref.documentID;
    ref.updateData({'id': id});
    ds = await ref.get();
  }

  Future<void> delete() async {
    Firestore.instance.collection('posts').document(id).delete();
  }

  void emailUser({String subject = "", @required BuildContext context}) async {
    String emailId = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: uid)
        .getDocuments()
        .then((result) => result.documents.elementAt(0)['email']);
    if (emailId == null) {
      if (context == null) {
        throw ("Bad context and email in db is null!\nuid: $uid");
      }
      popupMenuBuilder(
          context,
          AlertDialog(
            title: Text("Bad Email ID!"),
            content: Text(
                "This is usually caused due to an issue with the database or if the user in question is using an old version of the app."),
          ),
          dismiss: true);
      return;
    }

    String url = 'mailto:$emailId?subject=$subject';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not perform email intent: $url');
    }
  }

  Future<void> loadFromDs() async {
    uid = ds['uid'];
    id = ds['id'];
    imageUrl = ds['imageUrl'];
    caption = ds['caption'];
    likedBy = new Set.from(ds['likedBy']);
    likes = likedBy == null ? 0 : likedBy.length;
    private = ds['private'];
    setLiked();
    if (ds['comments'] == null) {
      comments = new Map();
      serverUpdate();
    } else {
      comments = new Map.from(ds['comments']);
    }
  }

  void setLiked() {
    if (likedBy != null && likedBy.contains(currentUid)) liked = true;
  }
}
