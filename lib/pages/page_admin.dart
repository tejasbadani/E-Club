import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_e/pages/ewrite/ewrite_admin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import './member_area/member_area.dart';
import './gallery/gallery.dart';
import './enext/enext.dart';
import './settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_e/pages/ewrite/user_blogs.dart';
import './member_area/member_admin.dart';
import './member_area/member_application.dart';
import 'package:project_e/pages/ewrite/ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageAdminState();
  }
}

SharedPreferences prefs;

class _PageAdminState extends State<PageAdmin> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _currentIndex = 2;
  List<Widget> _children;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isMemberAdmin;
  bool isEWriteAdmin;
  bool isMember;
  GlobalKey _key1 = GlobalKey();
  bool _didShowTutorialMember = false;

  Widget buildBottomBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_1.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'WRITERS',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
            ),
            activeIcon: Image.asset('assets/asset_6.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/openings_1.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'OPENINGS',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
            ),
            activeIcon: Image.asset('assets/openings.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_3.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'AGENCY',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
            ),
            activeIcon: Image.asset('assets/asset_8.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_4.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'GALLERY',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
            ),
            activeIcon: Image.asset('assets/asset_9.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_5.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'SETTINGS',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
            ),
            activeIcon: Image.asset('assets/asset_10.png')),
      ],
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.shifting,
    );
  }

  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isMemberAdmin = prefs.getBool('isMemberAdmin');
      isEWriteAdmin = prefs.getBool('isEWriteAdmin');
      isMember = prefs.getBool('isMember');
      _didShowTutorialMember = prefs.getBool('tut_member');
    });
  }

  @override
  void initState() {
    super.initState();
    //firebaseCloudMessaging();
    _children = [EWrite(), Enext(), MemberArea(), Gallery(), Settings()];
    _getData();

    checkIfLoggedIn();
    Future.delayed(Duration(seconds: 2), () {
      notificationShow();
    });
  }

  void checkIfLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn == false) {
      errorOccured();
    }
  }

  void errorOccured() {
    showDialog(
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops'),
          content: Text('Seems like your session timed out!'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                logOut();
              },
              child: Text('Login Again'),
            )
          ],
        );
      },
      context: context,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: Text('Would you like to receive updates from The Network?'),
          actions: <Widget>[
            RaisedButton(
              child: Text('YES'),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                didPressYes();
                prefs.setBool('notifdidAsk', true);
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('NO'),
              onPressed: () {
                prefs.setBool('notifdidAsk', true);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/Login');
  }

  void notificationShow() {
    bool notificationStatus = prefs.getBool('notifdidAsk');
    if (notificationStatus == false || notificationStatus == null) {
      _showDialog(context);
    }
  }

  void didPressYes() {
    firebaseCloudMessaging();
  }

  void firebaseCloudMessaging() {
    if (Platform.isIOS) iosPermission();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      if (isMember) {
        Firestore.instance
            .collection('tokens')
            .document(token)
            .setData({'id': token});
      }
      Firestore.instance
          .collection('writerstoken')
          .document(token)
          .setData({'id': token});
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

  void iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    //notificationShow();

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          _currentIndex == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserBlogs()));
                  },
                  splashColor: Colors.transparent,
                  tooltip: 'YOUR BLOGS',
                  icon: Icon(Icons.person),
                  color: Theme.of(context).primaryColorDark,
                  highlightColor: Colors.transparent,
                  iconSize: 28.0,
                )
              : _currentIndex == 2
                  ? Stack(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemberApplication()));
                          },
                          icon: Icon(Icons.group_add),
                          tooltip: 'AGENCY APPLICATION',
                          key: _key1,
                          splashColor: Colors.transparent,
                          color: Theme.of(context).primaryColorDark,
                          iconSize: 28.0,
                          highlightColor: Colors.transparent,
                        ),
                      ],
                    )
                  : Container(),
        ],
        leading: _currentIndex == 0 && isEWriteAdmin == true
            ? IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EWriteAdmin()));
                },
                icon: Icon(Icons.star),
                tooltip: 'WRITES SPACE ADMIN',
                color: Theme.of(context).primaryColorDark,
                iconSize: 28.0,
              )
            : _currentIndex == 2 && isMemberAdmin == true
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemberAdmin()));
                    },
                    tooltip: 'AGENCY ADMIN',
                    icon: Icon(Icons.stars),
                    splashColor: Colors.transparent,
                    color: Theme.of(context).primaryColorDark,
                    iconSize: 28.0,
                    highlightColor: Colors.transparent,
                  )
                : Container(),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'THE NETWORK',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
      body: _children[_currentIndex],
    );
  }
}
