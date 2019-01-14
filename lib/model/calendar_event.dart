import 'package:flutter/material.dart';

class CalendarEvent {
  final String name;
  final String category;
  final String date;
  final Color color;
  final bool completed;
  CalendarEvent(
      {@required this.name,
      @required this.category,
      @required this.color,
      @required this.completed,
      @required this.date});
}
