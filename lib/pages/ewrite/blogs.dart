import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_e/widgets/ewrite/ewrite_list_tile.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './article.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Blogs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlogsState();
  }
}

class _BlogsState extends State<Blogs> with AutomaticKeepAliveClientMixin {
  final List<Post> posts = [];
  SharedPreferences prefs;
  bool _didShowSnackBar = false;
  //String id;
  @override
  bool get wantKeepAlive => true;
  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('snack2') != null) {
      _didShowSnackBar = prefs.getBool('snack2');
    }
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
          'Are you a writer? Click on the button on the top right to submit your articles.'),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          prefs.setBool('snack2', true);
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 15),
    );

    if (!_didShowSnackBar || _didShowSnackBar == null) {
      Scaffold.of(context).showSnackBar(snackBar);
      prefs.setBool('snack2', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    Future.delayed(Duration(seconds: 1), () {
      _showSnackBar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ITEMS ${posts.length}');
    return StreamBuilder(
      stream: Firestore.instance
          .collection('ewrite')
          .document('blogs')
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
