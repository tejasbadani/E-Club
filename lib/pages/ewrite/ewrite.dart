import 'package:flutter/material.dart';
import './blogs.dart';
import './e_club_write.dart';
import './start_ups.dart';

class EWrite extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _EWriteState();
  }
}

class _EWriteState extends State<EWrite> {
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
                  text: 'BLOGS',
                ),
                Tab(
                  text: 'E CLUB',
                ),
                Tab(
                  text: 'START UPS',
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[Blogs(), EclubWrite(), Startups()],
        ),
       
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}
