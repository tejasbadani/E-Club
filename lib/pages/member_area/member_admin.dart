import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/widgets/member_area/member_admin_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_e/widgets/floating_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 25),
        child: CustomFloating(),
      ),
      appBar: AppBar(
        title: Text(
          'MEMBER ADMIN',
          style: TextStyle(fontSize: 15),
        ),
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
