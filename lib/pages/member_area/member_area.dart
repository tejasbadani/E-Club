import 'package:flutter/material.dart';
import './e_area.dart';
import './calendar.dart';
import './member_list.dart';

class MemberArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberAreaState();
  }
}

class _MemberAreaState extends State<MemberArea> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'MEMBERS',
                ),
                Tab(
                  text: 'E AREA',
                ),
                Tab(
                  text: 'CALENDAR',
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[MemberList(), EArea(), Calendar()],
        ),
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}
