import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:project_e/widgets/member_area/member_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberListState();
  }
}

class _MemberListState extends State<MemberList>
    with AutomaticKeepAliveClientMixin {
  SharedPreferences prefs;
  bool _didShowSnackBar = false;
  @override
  bool get wantKeepAlive => true;
  final List<Member> membersList = [];
  final List<String> memberID = [];
  @override
  void initState() {
    super.initState();
    _getData();
    Future.delayed(Duration(seconds: 1), () {
      _showSnackBar(context);
    });
  }

  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('snack1') != null) {
      _didShowSnackBar = prefs.getBool('snack1');
    }
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
          'Are you an agent? Click on the button on the top right to join the agency.'),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          prefs.setBool('snack1', true);
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 15),
    );

    print(_didShowSnackBar);
    if (!_didShowSnackBar || _didShowSnackBar == null) {
      Scaffold.of(context).showSnackBar(snackBar);
      prefs.setBool('snack1', true);
    }
  }

  // void getData() async {
  //   final data = await Firestore.instance
  //       .collection('member-list')
  //       .document('active')
  //       .get();
  //   final userIDArray = data.data;
  //   Member user;
  //   print('DATA LENGTH ${userIDArray.keys}');
  //   userIDArray.forEach((key, value) {
  //     Firestore.instance
  //         .collection('users')
  //         .document(key)
  //         .get()
  //         .then((snapshot) {
  //       final userData = snapshot.data;
  //       user = Member(
  //           department: userData['department'],
  //           name: userData['name'],
  //           userID: key,
  //           profileURL: userData['photoUrl']);
  //       setState(() {
  //         membersList.add(user);
  //       });
  //     });
  //   });
  // }

  // Widget returnData() {
  //   return StreamBuilder(
  //     stream: Firestore.instance
  //         .collection('member-list')
  //         .document('active')
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         print('NO DATA');
  //       } else {
  //         final data = snapshot.data;
  //         data.forEach((key, value) {
  //           memberID.add(data.key);
  //         });
  //       }
  //     },
  //   );
  // }

  List<Member> members = [];
  @override
  Widget build(BuildContext context) {
    //getData();
    return StreamBuilder(
      stream: Firestore.instance
          .collection('member-area')
          .document('member-list')
          .collection('active')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('LOADING');
          return Container();
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final data = snapshot.data.documents[index];
              final Member member = Member(
                  department: data['department'],
                  name: data['name'],
                  profileURL: data['profileURL'],
                  userID: data.documentID);
              members.add(member);
              return MemberListTile(member);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }
}
