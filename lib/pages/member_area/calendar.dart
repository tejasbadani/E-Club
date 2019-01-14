import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/widgets/member_area/calendar_tile.dart';
import 'package:project_e/model/calendar_event.dart';
import 'dart:math';

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

class _CalendarState extends State<Calendar>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.cyan
  ];
  List<CalendarEvent> events = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildCalendar(),
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('calendar-events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print('LOADING');
                      return Container();
                    } else {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data.documents[index];
                          final _random = new Random();
                          final CalendarEvent cal = CalendarEvent(
                            category: data['description'],
                            name: data['name'],
                            date: data['date'],
                            completed: data['completed'],
                            color: colors[_random.nextInt(colors.length)],
                          );
                          events.add(cal);
                          return CalendarRow(cal);
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Positioned(
      left: 30.0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}
