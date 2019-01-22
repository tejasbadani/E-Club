import 'package:flutter/material.dart';
import 'package:project_e/model/member_list.dart';
import 'package:project_e/widgets/member_area/member_edit_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberEditState();
  }
}

class _MemberEditState extends State<MemberEdit>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final List<Member> membersList = [];
  final List<String> memberID = [];
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT',style: TextStyle(fontSize: 15),),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('all')
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
                    memberType: data['memberType'],
                    userID: data.documentID);
                members.add(member);
                // return Dismissible(
                //   key: Key(member.userID),
                //   background: Container(
                //     color: Colors.red,
                //   ),
                //   onDismissed: (DismissDirection direction){
                //     if(direction == DismissDirection.endToStart){
                //       print('EXECUTED');
                //     }
                //   },
                //   child: MemberEditListTile(member),
                // );
                return MemberEditListTile(member);
              },
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }
}
