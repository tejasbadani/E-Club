import 'package:flutter/material.dart';
import 'package:project_e/model/special_access_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialAccessWidget extends StatefulWidget {
  final SpecialAccessModel member;
  SpecialAccessWidget(this.member);
  @override
  State<StatefulWidget> createState() {
    return _SpecialAccessWidgetState();
  }
}

class _SpecialAccessWidgetState extends State<SpecialAccessWidget> {
  //Add list tile to check if the user is a e write member or an admin of the network.
  //Special access is only for you
  //Create a view where i can remove and add admin access to the members

  Widget _createAgencyAdminButton() {
    return Container(
      height: 30,
      width: 100,
      margin: EdgeInsets.only(right: 15, top: 5),
      child: RaisedButton(
        color: widget.member.isEWriteAdmin
            ? Theme.of(context).primaryColor
            : Colors.white,
        onPressed: () {
          Firestore.instance
              .collection('users')
              .document(widget.member.userID)
              .updateData({'isEWriteAdmin': !widget.member.isEWriteAdmin});
          //TODO: Save in shared preferences
        },
        child: Text(
          'A - W',
          style: TextStyle(
              fontSize: 13,
              color: widget.member.isEWriteAdmin
                  ? Colors.white
                  : Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _createEWriteAdminButton() {
    return Container(
      height: 30,
      width: 100,
      margin: EdgeInsets.only(right: 15, top: 5),
      child: RaisedButton(
        color: widget.member.isMemberAdmin
            ? Theme.of(context).primaryColor
            : Colors.white,
        onPressed: () {
          Firestore.instance
              .collection('users')
              .document(widget.member.userID)
              .updateData({'isMemberAdmin': !widget.member.isMemberAdmin});
          //TODO: Save in shared preferences
        },
        child: Text(
          'A - A',
          style: TextStyle(
              fontSize: 13,
              color: widget.member.isMemberAdmin
                  ? Colors.white
                  : Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.member.name),
      subtitle: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createAgencyAdminButton(),
              _createEWriteAdminButton()
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
    );
  }
}
