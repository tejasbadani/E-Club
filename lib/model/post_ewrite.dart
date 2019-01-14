import 'package:flutter/material.dart';

class Post {
  final String postID;
  final String title;
  final String subtitle;
  final String imageURL;
  final String userID;
  final String date;
  final String article;
  final String category;
  final bool isRejected;
  Post(
      {@required this.postID,
      @required this.title,
      @required this.subtitle,
      @required this.imageURL,
      @required this.date,
      @required this.userID,
      @required this.article,
      @required this.category,
      this.isRejected});
}
