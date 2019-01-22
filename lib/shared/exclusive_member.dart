import 'package:flutter/material.dart';
import 'package:project_e/pages/member_area/member_application.dart';

class Exclusive extends StatelessWidget {
  final String message;
  Exclusive(this.message);

  Widget _buildStar(BuildContext context) {
    return Container(
      child: Icon(
        Icons.star,
        size: 50,
        color: Color(0xFFCFB53B),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Text(
        message,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 20,
          color: Color(0xFFCFB53B),
        ),
      ),
    );
  }

  Widget _buildApplicationButton(BuildContext context) {
    return Container(
      width: 150,
      height: 40,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: RaisedButton(
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberApplication(),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Color(0xFFCFB53B),
          ),
        ),
        child: Text(
          'APPLY',
          style: TextStyle(
            color: Color(0xFFCFB53B),
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildStar(context),
          _buildText(context),
          _buildApplicationButton(context)
        ],
      ),
    );
  }
}
