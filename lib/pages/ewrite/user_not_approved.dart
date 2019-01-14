import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/widgets/ewrite/ewrite_list_tile.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './user_article.dart';

class UserNotApproved extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserNotApprovedState();
  }
}

class _UserNotApprovedState extends State<UserNotApproved>
    with AutomaticKeepAliveClientMixin {
  String id;
  @override
  void initState() {
    _getID();
    super.initState();
  }

  void _getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id');
    });
  }

  @override
  bool get wantKeepAlive => true;
  final List<Post> posts = [];
  @override
  Widget build(BuildContext context) {
    return id != null
        ? StreamBuilder(
            stream: Firestore.instance
                .collection('ewrite')
                .document('not_approved')
                .collection('not_approved_docs')
                .where('userID', isEqualTo: id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Text('NO ARTICLES YET'),
                  );
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data.documents[index];
                    final Post post = Post(
                        imageURL: data['imageURL'],
                        postID: data.documentID,
                        subtitle: data['author'],
                        title: data['title'],
                        date: data['date'],
                        userID: data['userID'],
                        article: data['article'],
                        category: data['category'],
                        isRejected: data['rejected']);
                    posts.add(post);
                    return GestureDetector(
                      child: EWriteListTile(post),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserArticle(post)));
                      },
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                );
              }

              if (snapshot.connectionState != ConnectionState.done) {
                return CupertinoActivityIndicator();
              }

              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Text('NOTHING HERE'),
                );
              }
            },
          )
        : Container();
  }
}
