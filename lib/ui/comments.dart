import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeal/data/app_data.dart';
import 'package:zeal/data/post.dart';
import 'package:zeal/ui/common.dart';
import 'package:zeal/ui/post.dart';

class Comments extends StatefulWidget {
  final Post p;

  Comments({this.p});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () =>
              popupMenuBuilder(context, AddCommentPopupContent(p: widget.p)),
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.edit),
          ),
          Text("Comments")
        ]),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => widget.p.reloadPostData().then((v) => setState(() {})),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserInfoRow(id: widget.p.uid, p: widget.p),
            LikesAndCaption(p: widget.p),
            Divider(),
            Expanded(child: CommentsList(p: widget.p)),
          ],
        ),
      ),
    );
  }
}

class CommentsList extends StatefulWidget {
  final Post p;

  CommentsList({@required this.p});

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    /*return ListView.builder(
        itemCount: widget.p.comments.length,
        itemBuilder: (context, index) {
          int adjIndex = (widget.p.comments.length - 1) - index;
          return UserComment(
              uid: widget.p.comments[postIdList[adjIndex]][0],
              content: widget.p.comments[postIdList[adjIndex]][1],
              delCb: () {
                if (!UserData().isAdmin && UserData().user.uid != widget.p.uid)
                  return;
                widget.p.comments.remove(postIdList[adjIndex]);
                widget.p.serverUpdate();
                widget.p.reloadPostData().then((v) => setState(
                    () => postIdList = List.from(widget.p.comments.keys)));
              });
        });*/
    return StreamBuilder(
        stream: Firestore.instance
            .collection('posts')
            .where('id', isEqualTo: widget.p.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return ListView.builder(
                itemCount: snapshot.data.documents[0]['comments'].length,
                itemBuilder: (context, index) {
                  widget.p.reloadPostData();
                  int adjIndex =
                      (snapshot.data.documents[0]['comments'].length - 1) -
                          index;
                  return UserComment(
                    uid: snapshot.data.documents[0]['comments'][
                        List.from(snapshot.data.documents[0]['comments'].keys)[
                            adjIndex]][0],
                    content: snapshot.data.documents[0]['comments'][
                        List.from(snapshot.data.documents[0]['comments'].keys)[
                            adjIndex]][1],
                    delCb: () {
                      if (!UserData().isAdmin &&
                          UserData().user.uid != widget.p.uid) return;
                      widget.p.reloadPostData();
                      widget.p.comments.remove(List.from(snapshot
                          .data.documents[0]['comments'].keys)[adjIndex]);
                      widget.p.serverUpdate();
                      widget.p.reloadPostData().then((v) => setState(() {}));
                    },
                  );
                  //return PostWidget(
                  //    p: Post(ds: snapshot.data.documents[adjIndex]));
                });
        });
  }
}

class UserComment extends StatefulWidget {
  final String uid;
  final String content;
  final VoidCallback delCb;

  UserComment(
      {@required this.uid, @required this.content, @required this.delCb});

  @override
  UserCommentState createState() {
    return UserCommentState();
  }
}

class UserCommentState extends State<UserComment> {
  String _imageUrl;
  String _userName = "";

  Future<void> _getUserName() async {
    await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.uid)
        .getDocuments()
        .then((result) {
      var name = result.documents.length == 0
          ? ""
          : result.documents.elementAt(0)['name'];
      try {
        if (this.mounted && (name != null && name != "")) if (_userName != name)
          setState(() {
            _userName = name;
          });
        else
          _userName = name;
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> _getUserImageUrl() async {
    await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.uid)
        .getDocuments()
        .then((result) {
      var url = result.documents.length == 0
          ? ""
          : result.documents.elementAt(0)['photoUrl'];
      try {
        if (this.mounted && (url != null && url != "")) if (_imageUrl != url)
          setState(() {
            _imageUrl = url;
          });
        else
          _imageUrl = url;
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> _getStuff() async {
    await _getUserImageUrl();
    await _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    _getStuff();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              _imageUrl == null || _imageUrl == ""
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(_imageUrl)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        _userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(widget.content),
                    )
                  ],
                ),
              ),
            ],
          ),
          (!UserData().isAdmin && UserData().user.uid != widget.uid)
              ? Container()
              : FlatButton(
                  child: Icon(Icons.clear),
                  onPressed: widget.delCb,
                )
        ],
      ),
    );
  }
}

class AddCommentPopupContent extends StatefulWidget {
  final Post p;

  AddCommentPopupContent({@required this.p});

  @override
  _AddCommentPopupContentState createState() => _AddCommentPopupContentState();
}

class _AddCommentPopupContentState extends State<AddCommentPopupContent> {
  final _formKey = GlobalKey<FormState>();
  String _input;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(" Comment"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                      decoration: InputDecoration(
                        hintText: "Comment",
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Comment can't be empty!";
                        } else {
                          _input = value;
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Submit'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget.p.addComment(_input);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
