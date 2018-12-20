import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id = "undefined";
  String imageUrl;
  String caption = "";
  String uid = "";
  int likes = 0;
  bool liked = false;
  List<String> comments = new List();
  DocumentReference ref;

  Post({this.id, this.imageUrl, this.caption, this.uid, this.ref}) {
    if (ref == null)
      publishDoc();
    else
      loadFromRef();
  }

  void addComment(String comment) {
    comments.add(comment);
  }

  void like() {
    likes++;
    liked = true;
  }

  void unlike() {
    if (liked) {
      likes--;
      liked = false;
    }
  }

  void serverUpdate() {
    // Do stuff
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "imageUrl": imageUrl,
        "caption": caption,
        "likes": likes,
        "comments": comments
      };

  Future<void> publishDoc() async {
    ref = await Firestore.instance.collection('posts').add(this.toJson());
    id = ref.documentID;
    ref.updateData({'id': id});
  }

  Future<void> loadFromRef() async {
    DocumentSnapshot ds = await ref.get();
    id = ds['id'];
    imageUrl = ds['imageUrl'];
    caption = ds['caption'];
    likes = ds['likes'];
    comments = ds['comments'];
  }
}
