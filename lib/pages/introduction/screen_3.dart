import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            //color: Colors.red,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/screen3.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Baseline(
              baseline: MediaQuery.of(context).size.height / 1.35,
              baselineType: TextBaseline.ideographic,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'ASPIRING WRITER?',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'THIS CAN BE A GREAT WAY TO SHOWCASE YOUR TALENT!',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
