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
                  child: Text(
                    'BLOGS',
                    style: TextStyle(fontSize: 12),
                  ),
                  //text: 'BLOGS',
                ),
                Tab(
                  child: Text(
                    'E CLUB',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Tab(
                  child: Text(
                    'START UPS',
                    style: TextStyle(fontSize: 12),
                  ),
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
