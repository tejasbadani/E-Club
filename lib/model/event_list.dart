import 'package:flutter/material.dart';

class Event {
  final String name;
  final String image;
  final String id;
  final String article;
  Event(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.article});
}
