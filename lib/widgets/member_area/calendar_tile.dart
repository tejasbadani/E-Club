import 'package:flutter/material.dart';
import 'package:project_e/model/calendar_event.dart';

class CalendarRow extends StatefulWidget {
  final CalendarEvent event;
  final double dotSize = 12.0;
  CalendarRow(this.event);
  @override
  State<StatefulWidget> createState() {
    return _CalendarRowState();
  }
}

class _CalendarRowState extends State<CalendarRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 32.0 - widget.dotSize / 2),
            child: Container(
              height: widget.dotSize,
              width: widget.dotSize,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: widget.event.color),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.event.name,
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  widget.event.category,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              widget.event.date,
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
