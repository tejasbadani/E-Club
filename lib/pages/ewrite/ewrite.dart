import 'package:flutter/material.dart';
import './blogs.dart';

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
            title: Text(
              'ARTICLES',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        body: Blogs(),
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}
