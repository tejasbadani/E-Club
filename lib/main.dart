import 'package:flutter/material.dart';
import './pages/page_admin.dart';
import './pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:project_e/pages/introduction/introduction.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  //GoogleSignIn googleSignIn;
  bool _isLoggedIn = false;
  //bool _googleSignedIn = false;

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void login() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('id');

    //_googleSignedIn = await googleSignIn.isSignedIn();
    if (token != null) {
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
    firebaseCloudMessaging_Listeners();
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
          accentColor: Colors.white,
          backgroundColor: Colors.grey,
          fontFamily: 'Rubik'),
      home: _isLoggedIn ? PageAdmin() : Introduction(),
      routes: {
        '/Main': (BuildContext context) => PageAdmin(),
        '/Login': (BuildContext context) => Login()
      },
    );
  }
}
