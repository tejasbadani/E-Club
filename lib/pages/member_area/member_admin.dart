import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/widgets/member_area/member_admin_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_e/widgets/floating_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberAdminState();
  }
}

class _MemberAdminState extends State<MemberAdmin> {
  List<Member> members = [];
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  @override
  void initState() {
    overlayState = Overlay.of(context);
    super.initState();
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

  void _activePressed(Member member) {
    Firestore.instance
        .collection('users')
        .document(member.userID)
        .updateData({'memberType': 'active', 'isMember': true});
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
        .document(member.userID)
        .delete();
    final data = {
      'department': member.department,
      'name': member.name,
      'profileURL': member.profileURL,
      'memberType': 'active'
    };
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('all')
        .document(member.userID)
        .setData(data);
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('active')
        .document(member.userID)
        .setData(data)
        .then((val) {
      Navigator.pop(context);
    });
  }

  void _dormantPressed(Member member) {
    Firestore.instance.collection('users').document(member.userID).updateData(
      {'memberType': 'dormant', 'isMember': true},
    );
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
        .document(member.userID)
        .delete();
    final data = {
      'department': member.department,
      'name': member.name,
      'profileURL': member.profileURL,
      'memberType': 'dormant'
    };
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('all')
        .document(member.userID)
        .setData(data);
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('dormant')
        .document(member.userID)
        .setData(data)
        .then((val) {
      Navigator.pop(context);
    });
  }

  void _rejected(Member member) {
    Firestore.instance
        .collection('member-area')
        .document('member-list')
        .collection('pending')
        .document(member.userID)
        .delete();
    Firestore.instance
        .collection('users')
        .document(member.userID)
        .updateData({'hasSentRequest': false});
  }

  void _showDialog(BuildContext context, Member member) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('APPROVE?'),
            content: Text('CHOOSE ONE OF THE BELOW'),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('ACTIVE'),
                    onPressed: () {
                      _activePressed(member);
                    },
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('DORMANT'),
                    onPressed: () {
                      _dormantPressed(member);
                    },
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('REJECT'),
                    onPressed: () {
                      _rejected(member);
                    },
                  ),
                  // RaisedButton(
                  //   color: Theme.of(context).primaryColor,
                  //   child: Text('ALUMNI'),
                  //   onPressed: () {
                  //     Firestore.instance
                  //         .collection('users')
                  //         .document(member.userID)
                  //         .updateData(
                  //             {'memberType': 'alumni', 'isMember': false});
                  //     Firestore.instance
                  //         .collection('member-area')
                  //         .document('member-list')
                  //         .collection('pending')
                  //         .document(member.userID)
                  //         .delete();
                  //     final data = {
                  //       'department': member.department,
                  //       'name': member.name,
                  //       'profileURL': member.profileURL,
                  //       'memberType': 'alumni'
                  //     };
                  //     Firestore.instance
                  //         .collection('member-area')
                  //         .document('member-list')
                  //         .collection('alumni')
                  //         .document(member.userID)
                  //         .setData(data)
                  //         .then((val) {
                  //       Navigator.pop(context);
                  //     });
                  //   },
                  // ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          );
        },
        context: context,
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 25), child: CustomFloating()

          // FloatingActionButton(
          //   onPressed: () {
          //     //DO NOTHING
          //   },
          //   backgroundColor: Theme.of(context).primaryColor,
          //   child: IconButton(
          //     icon: Icon(Icons.image),
          //     color: Colors.white,
          //     onPressed: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => AddImage()));
          //     },
          //   ),
          // ),
          ),
      appBar: AppBar(
        title: Text('MEMBER ADMIN'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text('NO PENDING REQUESTS'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = snapshot.data.documents[index];
                final Member member = Member(
                    department: data['department'],
                    name: data['name'],
                    profileURL: data['profileURL'],
                    userID: data.documentID,
                    memberType: data['memberType']);
                members.add(member);
                return MemberAdminTile(member);
              },
              itemCount: snapshot.data.documents.length,
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text('NO REQUESTS'),
            );
          }
        },
      ),
    );
  }
}
