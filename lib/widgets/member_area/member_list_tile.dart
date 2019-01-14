import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';

class MemberListTile extends StatefulWidget {
  final Member member;
  MemberListTile(this.member);
  @override
  State<StatefulWidget> createState() {
    return _MemberListTileState();
  }
}

class _MemberListTileState extends State<MemberListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          
          isThreeLine: true,
          title: Container(
            child: Text(
              widget.member.name,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.only(top: 30),
          ),
          subtitle: Container(
            child: Text(
              widget.member.department,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300,color: Colors.black),
            ),
            margin: EdgeInsets.only(bottom: 30.0),
          ),
          leading: Container(
            
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.member.profileURL),
              
              backgroundColor: Colors.lightBlue,
            ),
            margin: EdgeInsets.symmetric(vertical: 30),
          ),
        ),
        Divider(),
      ],
    );
  }
}
