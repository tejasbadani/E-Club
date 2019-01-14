import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberEditListTile extends StatefulWidget {
  final Member member;
  MemberEditListTile(this.member);
  @override
  State<StatefulWidget> createState() {
    return _MemberEditListTileState();
  }
}

class _MemberEditListTileState extends State<MemberEditListTile> {
  void _onActivePressed() {
    if (widget.member.memberType == 'active') {
      //DO NOTHING
    } else if (widget.member.memberType == 'dormant') {
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('all')
          .document(widget.member.userID)
          .updateData({'memberType': 'active'});
      Firestore.instance
          .collection('users')
          .document(widget.member.userID)
          .updateData({'memberType': 'active'});
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('dormant')
          .document(widget.member.userID)
          .delete();
      final data = {
        'department': widget.member.department,
        'name': widget.member.name,
        'profileURL': widget.member.profileURL,
        'memberType': 'active'
      };
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('active')
          .document(widget.member.userID)
          .setData(data);
      setState(() {
        widget.member.memberType = 'active';
      });
    }
  }

  void _onDormantPressed() {
    if (widget.member.memberType == 'dormant') {
      //DO NOTHING
    } else if (widget.member.memberType == 'active') {
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('all')
          .document(widget.member.userID)
          .updateData({'memberType': 'dormant'});
      Firestore.instance
          .collection('users')
          .document(widget.member.userID)
          .updateData({'memberType': 'dormant'});
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('active')
          .document(widget.member.userID)
          .delete();
      final data = {
        'department': widget.member.department,
        'name': widget.member.name,
        'profileURL': widget.member.profileURL,
        'memberType': 'dormant'
      };
      Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('dormant')
          .document(widget.member.userID)
          .setData(data);
      setState(() {
        widget.member.memberType = 'dormant';
      });
    }
  }

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
            margin: EdgeInsets.only(top: 20),
          ),
          subtitle: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: RaisedButton(
                        color: widget.member.memberType == 'active'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        onPressed: () {
                          _onActivePressed();
                        },
                        child: Text(
                          'ACTIVE',
                          style: TextStyle(
                              color: widget.member.memberType != 'active'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: RaisedButton(
                        color: widget.member.memberType == 'dormant'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        onPressed: () {
                          _onDormantPressed();
                        },
                        child: Text(
                          'DORMANT',
                          style: TextStyle(
                              color: widget.member.memberType != 'dormant'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //margin: EdgeInsets.only(bottom: 30.0),
          ),
          leading: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.member.profileURL),
              backgroundColor: Colors.lightBlue,
            ),
            //margin: EdgeInsets.symmetric(vertical: 30),
          ),
        ),
        Divider(),
      ],
    );
  }
}
