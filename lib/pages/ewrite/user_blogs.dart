import 'package:flutter/material.dart';
import './create_article.dart';
import './user_approved.dart';
import './user_not_approved.dart';

class UserBlogs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserBlogsState();
  }
}

class _UserBlogsState extends State<UserBlogs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('YOUR SUBMISSIONS'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateArticle()));
              },
              icon: Icon(Icons.create),
              iconSize: 32,
              color: Theme.of(context).accentColor,
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'APPROVED',
              ),
              Tab(
                text: 'NOT APPROVED',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[UserApproved(), UserNotApproved()],
        ),
      ),
      length: 2,
      initialIndex: 0,
    );
  }
}
