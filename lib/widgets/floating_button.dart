import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:project_e/pages/member_area/member_edit.dart';
import 'package:project_e/pages/member_area/new_calendar.dart';
import 'package:project_e/pages/member_area/new_gallery.dart';

class CustomFloating extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CustomFloatingState();
  }
}

class _CustomFloatingState extends State<CustomFloating>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              heroTag: 'image',
              mini: true,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddImage()));
              },
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              heroTag: 'calendar',
              mini: true,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCalendarEvent()));
              },
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              heroTag: 'edit',
              mini: true,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MemberEdit()));
              },
              child: Icon(Icons.people, color: Colors.white),
            ),
          ),
        ),
        FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          heroTag: 'options',
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                child: Icon(
                  _controller.isDismissed ? Icons.more_vert : Icons.close,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
