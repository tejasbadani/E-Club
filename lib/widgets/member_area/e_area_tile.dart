import 'package:flutter/material.dart';
import 'package:project_e/model/member_area.dart';

class MemberAreaTile extends StatefulWidget {
  final Message message;
  MemberAreaTile(this.message);

  @override
  State<StatefulWidget> createState() {
    return _MemberAreaTileState();
  }
}

class _MemberAreaTileState extends State<MemberAreaTile> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                      radius: _height > 650 ?20.0 : 18,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: NetworkImage(widget.message.profileURL)),
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                ),
                Text(
                  widget.message.name.toUpperCase(),
                  style: TextStyle(
                      fontSize: _height > 650 ? 20.0 : 15.0,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  child: Text(
                    widget.message.date,
                    style: TextStyle(
                        fontSize: _height > 650 ? 15.0 : 12.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 10),
          ),
          subtitle: Container(
            child: Text(
              widget.message.message,
              style: TextStyle(fontSize:  15.0, color: Colors.black),
            ),
            margin: EdgeInsets.only(bottom: 30.0, left: 0, top: 10),
          ),
        ),
        Divider(),
      ],
    );
  }
}
