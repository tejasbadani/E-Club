import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            //color: Colors.red,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/screen1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Baseline(
                baseline: MediaQuery.of(context).size.height / 2,
                baselineType: TextBaseline.ideographic,
                child: Text(
                  
                  'WELCOME TO THE NETWORK',
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
