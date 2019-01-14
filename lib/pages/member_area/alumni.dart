import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/model/member_list.dart';
import 'package:project_e/widgets/member_area/member_list_tile.dart';
import 'package:flutter/cupertino.dart';

class Alumni extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AlumniState();
  }
}

class _AlumniState extends State<Alumni> {
  List<Member> members = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni List'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('alumni')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text('NO ALUMNI YET'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = snapshot.data.documents[index];
                final Member member = Member(
                    department: data['department'],
                    name: data['name'],
                    profileURL: data['profileURL'],
                    memberType: data['memberType'],
                    userID: data.documentID);
                members.add(member);
                return MemberListTile(member);
              },
              itemCount: snapshot.data.documents.length,
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return CupertinoActivityIndicator();
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text('NOTHING YET'),
            );
          }
        },
      ),
    );
  }
}
