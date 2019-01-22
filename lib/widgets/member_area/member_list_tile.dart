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
              widget.member.name.toUpperCase(),
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.only(top: 20),
          ),
          subtitle: Container(
            child: Text(
              widget.member.department.toUpperCase(),
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400,color: Colors.black),
            ),
            //margin: EdgeInsets.only(bottom: 20.0),
          ),
          leading: Container(
            
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(widget.member.profileURL),
              
              backgroundColor: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.only(top: 20),
          ),
          //trailing: Icon(Icons.star,),
        ),
        //Divider(),
      ],
    );
  }
}
