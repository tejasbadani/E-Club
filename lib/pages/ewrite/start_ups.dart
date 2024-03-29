import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import './article.dart';
import 'package:project_e/widgets/ewrite/ewrite_list_tile.dart';

class Startups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartupsState();
  }
}

class _StartupsState extends State<Startups>
    with AutomaticKeepAliveClientMixin {
  final List<Post> posts = [];
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('ewrite')
          .document('start-ups')
          .collection('approved')
          .orderBy('date', descending: true)
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
              );
              posts.add(post);
              return GestureDetector(
                child: EWriteListTile(post),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Article(post)));
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
            child: Text('NO BLOGS'),
          );
        }
      },
    );
  }
}
