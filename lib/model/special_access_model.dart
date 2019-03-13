import 'package:flutter/material.dart';

class SpecialAccessModel {
  final String name;
  final String department;
  final String profileURL;
  final String userID;
  final bool isEWriteAdmin;
  final bool isMemberAdmin;
  SpecialAccessModel({
    @required this.name,
    @required this.department,
    @required this.profileURL,
    @required this.userID,
    @required this.isEWriteAdmin,
    @required this.isMemberAdmin,
  });
}
