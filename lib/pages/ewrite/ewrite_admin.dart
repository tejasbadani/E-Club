import 'package:flutter/material.dart';
import './not_approved_admin.dart';
import './approved_admin.dart';

class EWriteAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EWriteAdminState();
  }
}

class _EWriteAdminState extends State<EWriteAdmin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('WRITERS SPACE ADMIN',style: TextStyle(fontSize: 15),),
          bottom: TabBar( 
            tabs: <Widget>[
              Tab(
                  child: Text(
                    'PENDING',
                    style: TextStyle(fontSize: 12),
                  ),
                  //text: 'BLOGS',
                ),
              Tab(
                  child: Text(
                    'APPROVED',
                    style: TextStyle(fontSize: 12),
                  ),
                  //text: 'BLOGS',
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[NotApproved(), Approved()],
        ),
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}
