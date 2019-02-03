import 'package:flutter/material.dart';

class RegistrationTile extends StatefulWidget {
  final String name;
  final String profileURL;
  final String phone;
  RegistrationTile(
      {@required this.name, @required this.profileURL, @required this.phone});
  @override
  State<StatefulWidget> createState() {
    return _RegistrationTileState();
  }
}

class _RegistrationTileState extends State<RegistrationTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          isThreeLine: true,
          title: Container(
            child: Text(
              widget.name.toUpperCase(),
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
            ),
            margin: EdgeInsets.only(top: 20),
          ),
          subtitle: Container(
            child: Text(
              widget.phone.toUpperCase(),
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            //margin: EdgeInsets.only(bottom: 20.0),
          ),
          leading: Container(
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(widget.profileURL),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.only(top: 20),
          ),
          //trailing: Icon(Icons.star,),
        ),
        //Divider(),
      ],
    );
  }
}
