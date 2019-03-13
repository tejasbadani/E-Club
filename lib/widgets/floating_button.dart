import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:project_e/pages/member_area/member_edit.dart';
import 'package:project_e/pages/member_area/new_calendar.dart';
import 'package:project_e/pages/member_area/new_gallery.dart';
import 'package:project_e/pages/member_area/registration.dart';
import 'package:project_e/pages/member_area/special_access.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFloating extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CustomFloatingState();
  }
}

class _CustomFloatingState extends State<CustomFloating>
    with TickerProviderStateMixin {
  AnimationController _controller;
  SharedPreferences prefs;
  bool specialAccess = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
    _getData();
  }

  Widget _returnRegistrationPage() {
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          heroTag: 'reg',
          mini: true,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Registration()));
          },
          child: Icon(
            Icons.receipt,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _returnAddImagePage() {
    return Container(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddImage()));
          },
          child: Icon(
            Icons.image,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _returnAddCalendarPage() {
    return Container(
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateCalendarEvent()));
          },
          child: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _returnEditMemberPage() {
    return Container(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MemberEdit()));
          },
          child: Icon(Icons.people, color: Colors.white),
        ),
      ),
    );
  }

  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      print('BOOL ${prefs.getBool('specialAccess')}');
      specialAccess = prefs.getBool('specialAccess');
    });
  }

  Widget _returnSpecialAccessPage() {
    return Container(
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
          heroTag: 'special',
          mini: true,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SpecialAccess()));
          },
          child: Icon(Icons.star, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _returnRegistrationPage(),
        _returnAddImagePage(),
        _returnAddCalendarPage(),
        _returnEditMemberPage(),
        specialAccess == true
            ? _returnSpecialAccessPage()
            : Visibility(
                child: _returnSpecialAccessPage(),
                visible: false,
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
