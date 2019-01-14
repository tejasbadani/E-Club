import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './new_evoice.dart';
import 'package:project_e/model/member_area.dart';
import 'package:project_e/widgets/member_area/e_area_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EAreaState();
  }
}

class _EAreaState extends State<EArea> with AutomaticKeepAliveClientMixin {
  final List<Message> messages = [];
  SharedPreferences prefs;
  @override
  bool get wantKeepAlive => true;

  bool _isMember;
  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMember = prefs.getBool('isMember');
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isMember == true
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add_comment, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewVoice()));
              },
            ),
            body: StreamBuilder(
              stream: Firestore.instance
                  .collection('evoice')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('LOADING');
                  return Container();
                } else {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data.documents[index];
                      final Message message = Message(
                        date: data['date'],
                        name: data['username'],
                        message: data['message'],
                        profileURL: data['profileURL'],
                        userID: data['userID'],
                      );
                      return MemberAreaTile(message);
                    },
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          )
        : Scaffold(
            body: Center(
              child: Text('YOU NEED TO BE A MEMBER TO VIEW THIS PAGE'),
            ),
          );
  }
}
