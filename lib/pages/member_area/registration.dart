import 'package:flutter/material.dart';
import 'package:project_e/widgets/member_area/registration_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<Registration>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'REGISTRATIONS',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('registrations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('LOADING');
            return Container();
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = snapshot.data.documents[index];
                final name = data['name'];
                final phone = data['number'];
                final url = data['profileURL'];
                return RegistrationTile(
                    name: name, phone: phone, profileURL: url);
              },
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }
}
