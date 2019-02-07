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
  List postIdList;

  @override
  Widget build(BuildContext context) {
    postIdList = List.from(widget.p.comments.keys);
    return ListView.builder(
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
                setState(() {});
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
  String imageUrl;
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
        if (this.mounted && (name != null && name != ""))
          setState(() {
            _userName = name;
          });
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
        if (this.mounted && (url != null && url != ""))
          setState(() {
            imageUrl = url;
          });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUserImageUrl();
    _getUserName();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              imageUrl == null || imageUrl == ""
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(imageUrl)),
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
