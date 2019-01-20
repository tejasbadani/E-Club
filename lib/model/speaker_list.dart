import 'package:flutter/material.dart';

class Speaker {
  final String name;
  final String image;
  final String id;
  final String article;
  final String instagramURL;
  final String facebookURL;
  final String linkedInURL;

  Speaker(
      {@required this.name,
      @required this.image,
      @required this.id,
      @required this.article,
      @required this.instagramURL,
      @required this.facebookURL,
      @required this.linkedInURL});
}
