import 'package:flutter/material.dart';

class Message {
  final String userID;
  final String message;
  final String profileURL;
  final String name;
  final String date;
  Message(
      {@required this.message,
      @required this.userID,
      @required this.profileURL,
      @required this.name,
      @required this.date});
}
