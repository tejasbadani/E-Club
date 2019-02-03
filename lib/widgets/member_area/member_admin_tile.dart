import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberAdminTile extends StatefulWidget {
  final Member member;
  MemberAdminTile(this.member);
  @override
  State<StatefulWidget> createState() {
    return _MemberAdminTileState();
  }
}

class _MemberAdminTileState extends State<MemberAdminTile> {
  void _activeMember() async {
    try {
      bool _to = false;
      final data = {
        'department': widget.member.department,
        'name': widget.member.name,
        'profileURL': widget.member.profileURL,
      };
      Firestore.instance
          .collection('users')
          .document(widget.member.userID)
          .updateData({ 'isMember': true}).timeout(
              Duration(seconds: 30), onTimeout: () {
        _showToast(Colors.red, 'Request Timed out');
        _to = true;
      });
      if (_to) {
        _to = false;
      } else {
        Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('pending')
            .document(widget.member.userID)
            .delete()
            .timeout(Duration(seconds: 30), onTimeout: () {
          _showToast(Colors.red, 'Request Timed out');
          _to = true;
        });
        if (_to) {
          _to = false;
        } else {
          Firestore.instance
              .collection('member-area')
              .document('member-list')
              .collection('active')
              .document(widget.member.userID)
              .setData(data)
              .timeout(Duration(seconds: 30), onTimeout: () {
            _showToast(Colors.red, 'Request Timed out');
            _to = true;
          });
        }
      }
    } catch (e) {
      _showToast(Colors.red, 'An error occured');
    }
  }

  void _showToast(Color color, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        textColor: Colors.white,
        backgroundColor: color);
  }

  // void _dormantMember() async {
  //   final data = {
  //     'department': widget.member.department,
  //     'name': widget.member.name,
  //     'profileURL': widget.member.profileURL,
  //     'memberType': 'dormant'
  //   };
  //   bool _to = false;
  //   bool _done = true;
  //   await Firestore.instance
  //       .collection('users')
  //       .document(widget.member.userID)
  //       .updateData(
  //     {'memberType': 'dormant', 'isMember': true},
  //   ).timeout(Duration(seconds: 30), onTimeout: () {
  //     _showToast(Colors.red, 'Request Timed out');
  //     _to = true;
  //   });
  //   if (_to) {
  //     _to = false;
  //   } else {
  //     await Firestore.instance
  //         .collection('member-area')
  //         .document('member-list')
  //         .collection('pending')
  //         .document(widget.member.userID)
  //         .delete()
  //         .timeout(Duration(seconds: 30), onTimeout: () {
  //       _showToast(Colors.red, 'Request Timed out');
  //       _to = true;
  //     });
  //     if (_to) {
  //       _to = false;
  //     } else {
  //       await Firestore.instance
  //           .collection('member-area')
  //           .document('member-list')
  //           .collection('all')
  //           .document(widget.member.userID)
  //           .setData(data)
  //           .timeout(Duration(seconds: 30), onTimeout: () {
  //         _showToast(Colors.red, 'Request Timed out');
  //         _to = true;
  //       });
  //       if (_to) {
  //         _to = false;
  //       } else {
  //         await Firestore.instance
  //             .collection('member-area')
  //             .document('member-list')
  //             .collection('dormant')
  //             .document(widget.member.userID)
  //             .setData(data)
  //             .timeout(Duration(seconds: 30), onTimeout: () {
  //           _done = false;
  //           _showToast(Colors.red, 'Request Timed out');
  //         });
  //         if (_done) {
  //           _showToast(Colors.green, 'Action Completed');
  //         }
  //       }
  //     }
  //   }
  // }

  void _rejectMember() async {
    bool _to = false;
    bool _done = true;
    await Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
        .document(widget.member.userID)
        .delete()
        .timeout(Duration(seconds: 30), onTimeout: () {
      _showToast(Colors.red, 'Request Timed out');
      _to = true;
    });
    if (_to) {
      _to = false;
    } else {
      await Firestore.instance
          .collection('users')
          .document(widget.member.userID)
          .updateData({'hasSentRequest': false}).timeout(Duration(seconds: 30),
              onTimeout: () {
        _done = false;
        _showToast(Colors.red, 'Request Timed out');
      });
      if (_done) {
        _showToast(Colors.green, 'Action Completed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        ListTile(
          //isThreeLine: true,
          title: Container(
            child: Text(
              widget.member.name.toUpperCase(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.only(top: 10),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: _height > 650 ? 40 : 30,
                    width: _height > 650 ? 100 : 90,
                    margin: EdgeInsets.only(right: 15, top: 10),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        //_onActivePressed();
                        _activeMember();
                      },
                      child: Text(
                        'ACCEPT',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: _height > 650 ? 15 : 13,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: _height > 650 ? 40 : 30,
                    width: _height > 650 ? 100 : 90,
                    margin: EdgeInsets.only(right: 15, top: 10),
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
                          fontSize: _height > 650 ? 15 : 13,
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
              radius: 23,
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
