import 'package:flutter/material.dart';
import './pages/page_admin.dart';
import './pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e/pages/introduction/introduction.dart';
import 'package:google_sign_in/google_sign_in.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  //GoogleSignIn googleSignIn;
  bool _isLoggedIn = false;
  //bool _googleSignedIn = false;

  void login() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('id');

    //_googleSignedIn = await googleSignIn.isSignedIn();
    if (token != null ) {
      setState(() {
        _isLoggedIn = true;
      });
      Firestore.instance.collection('users').document(token).get().then((val) {
        final documents = val.data;
        if (documents != null) {
          if (documents['isMemberAdmin'] == null ||
              documents['hasSentRequest'] == null ||
              documents['isMember'] == null ||
              documents['memberType'] == null ||
              documents['isEWriteAdmin'] == null) {
            Firestore.instance.collection('users').document(token).updateData({
              'hasSentRequest': false,
              'isMember': false,
              'memberType': 'none',
              'isMemberAdmin': false,
              'isEWriteAdmin': false
            });

            prefs.setBool('hasSentRequest', false);
            prefs.setBool('isMember', false);
            prefs.setBool('isMemberAdmin', false);
            prefs.setBool('isEWriteAdmin', false);
            prefs.setString('memberType', 'none');
          } else {
            prefs.setBool('hasSentRequest', documents['hasSentRequest']);
            prefs.setBool('isMember', documents['isMember']);
            prefs.setBool('isMemberAdmin', documents['isMemberAdmin']);
            prefs.setBool('isEWriteAdmin', documents['isEWriteAdmin']);
            prefs.setString('memberType', documents['memberType']);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E CLUB',
      theme: ThemeData(
          buttonColor: Color(0xFF003366),
          primaryColor: Color(0xFF003366),
          primaryColorDark: Colors.white,
          accentColor: Color(0xFFd3d3d3),
          backgroundColor: Colors.grey,
          fontFamily: 'Rubik'),
      home: _isLoggedIn ? PageAdmin() : Introduction(),
      routes: {
        '/Main': (BuildContext context) => PageAdmin(),
        '/Login': (BuildContext context) => Login(),
        '/Intro': (BuildContext context) => Introduction()
      },
    );
  }
}
