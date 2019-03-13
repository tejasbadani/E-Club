import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/model/special_access_model.dart';
import 'package:project_e/widgets/member_area/special_access_widget.dart';

class SpecialAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SpecialAccessState();
  }
}

class _SpecialAccessState extends State<SpecialAccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SPECIAL ACCESS',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: _createListView(),
    );
  }

  Widget _createListView() {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('LOADING');
          return Container();
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              final data = snapshot.data.documents[index];
              final member = SpecialAccessModel(
                department: data['department'],
                isEWriteAdmin: data['isEWriteAdmin'],
                isMemberAdmin: data['isMemberAdmin'],
                userID: data.documentID,
                name: data['name'],
                profileURL: data['photoUrl'],
              );
              return SpecialAccessWidget(member);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }
}
