import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberAdminTile extends StatefulWidget {
  final Member member;
  MemberAdminTile(this.member);
  @override
  State<StatefulWidget> createState() {
    return _MemberAdminTileState();
  }
}

class _MemberAdminTileState extends State<MemberAdminTile> {
  void _activeMember() {
    Firestore.instance
        .collection('users')
        .document(widget.member.userID)
        .updateData({'memberType': 'active', 'isMember': true});
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
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
        .collection('all')
        .document(widget.member.userID)
        .setData(data);
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('active')
        .document(widget.member.userID)
        .setData(data)
        .then((val) {});
  }

  void _dormantMember() {
    Firestore.instance
        .collection('users')
        .document(widget.member.userID)
        .updateData(
      {'memberType': 'dormant', 'isMember': true},
    );
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
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
        .collection('all')
        .document(widget.member.userID)
        .setData(data);
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('dormant')
        .document(widget.member.userID)
        .setData(data)
        .then((val) {});
  }

  void _rejectMember() {
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
        .document(widget.member.userID)
        .delete();
    Firestore.instance
        .collection('users')
        .document(widget.member.userID)
        .updateData({'hasSentRequest': false});
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
            margin: EdgeInsets.only(top: 30),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        //_onActivePressed();
                        _activeMember();
                      },
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        //_onDormantPressed();
                        _dormantMember();
                      },
                      child: Text(
                        'DORMANT',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        //_onActivePressed();
                        _rejectMember();
                      },
                      child: Text(
                        'REJECT',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
