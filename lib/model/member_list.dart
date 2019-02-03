import 'package:flutter/material.dart';

class Member {
  final String name;
  final String department;
  final String profileURL;
  final String userID;
  Member({
    @required this.name,
    @required this.department,
    @required this.profileURL,
    @required this.userID,
  });
}
