import 'package:flutter/material.dart';

class ExclusiveActive extends StatelessWidget {
  final String message;
  ExclusiveActive(this.message);

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildStar(context),
          _buildText(context),
        ],
      ),
    );
  }
}
