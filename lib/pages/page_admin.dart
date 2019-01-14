import 'package:flutter/material.dart';

import 'package:project_e/pages/ewrite/ewrite_admin.dart';

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

class PageAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageAdminState();
  }
}

SharedPreferences prefs;

class _PageAdminState extends State<PageAdmin> {
  int _currentIndex = 2;
  List<Widget> _children;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isMemberAdmin;
  bool isEWriteAdmin;
  Widget buildBottomBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_1.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'E WRITE',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            activeIcon: Image.asset('assets/asset_6.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_2.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'E NEXT',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            activeIcon: Image.asset('assets/asset_7.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_3.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'MEMBERS AREA',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            activeIcon: Image.asset('assets/asset_8.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_4.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'GALLERY',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            activeIcon: Image.asset('assets/asset_9.png')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/asset_5.png'),
            title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                'SETTINGS',
                style: TextStyle(color: Theme.of(context).primaryColor),
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
    });
  }

  @override
  void initState() {
    super.initState();
    _children = [EWrite(), Enext(), MemberArea(), Gallery(), Settings()];
    _getData();
    checkIfLoggedIn();
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

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          _currentIndex == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserBlogs()));
                  },
                  icon: Icon(Icons.person),
                  color: Theme.of(context).primaryColorDark,
                  iconSize: 32.0,
                )
              : _currentIndex == 2
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemberApplication()));
                      },
                      icon: Icon(Icons.group_add),
                      color: Theme.of(context).primaryColorDark,
                      iconSize: 32.0,
                    )
                  : Container(),
        ],
        leading: _currentIndex == 0 && isEWriteAdmin == true
            ? IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EWriteAdmin()));
                },
                icon: Icon(Icons.star),
                color: Theme.of(context).primaryColorDark,
                iconSize: 30.0,
              )
            : _currentIndex == 2 && isMemberAdmin == true
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemberAdmin()));
                    },
                    icon: Icon(Icons.stars),
                    color: Theme.of(context).primaryColorDark,
                    iconSize: 32.0,
                  )
                : Container(),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'E CLUB',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
      ),
      bottomNavigationBar: buildBottomBar(),
      body: _children[_currentIndex],
    );
  }
}
