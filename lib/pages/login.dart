import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/custom_loading.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  FirebaseUser currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  Future<Null> handleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      setState(() {
        _isLoading = false;
      });
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'name': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'hasSentRequest': false,
          'isMember': false,
          'isMemberAdmin': false,
          'isEWriteAdmin': false,
          'specialAccess': false,
        });
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('profileURL', currentUser.photoUrl);
        await prefs.setString('name', currentUser.displayName);
        await prefs.setBool('hasSentRequest', false);
        await prefs.setBool('isMember', false);
        await prefs.setBool('isMemberAdmin', false);
        await prefs.setBool('isEWriteAdmin', false);
        await prefs.setBool('specialAccess', false);
      } else {
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('profileURL', documents[0]['photoUrl']);
        await prefs.setString('name', documents[0]['name']);
        await prefs.setBool('hasSentRequest', documents[0]['hasSentRequest']);
        await prefs.setBool('isMember', documents[0]['isMember']);
        await prefs.setBool('isMemberAdmin', documents[0]['isMemberAdmin']);
        await prefs.setBool('isEWriteAdmin', documents[0]['isEWriteAdmin']);
        await prefs.setBool('specialAccess', documents[0]['specialAccess']);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/Main');
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorOccured();
      print('Failed Login');
    }
  }

  void _errorOccured() {
    showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops'),
          content: Text('Seems Like an error has occured'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            )
          ],
        );
      },
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    prefs = await SharedPreferences.getInstance();
    _isLoggedIn = await googleSignIn.isSignedIn();
    if (_isLoggedIn) {
      print('Logged in');
      print('ID is ${prefs.getString('id')}');
      Navigator.pushReplacementNamed(context, '/Main');
    }
  }

  void disabledButton() {
    print('Button Disabled');
  }

  @override
  Widget build(BuildContext context) {
    print('Height is ${MediaQuery.of(context).size.height}');
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.6,
            child: Container(
              //color: Colors.red,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/screen4.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset('assets/network_1.png'),
                  margin: EdgeInsets.only(top: 100),
                  height: 125,
                  width: 125,
                ),
                Container(
                  child: Text(
                    'PSG TECH',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                  margin: EdgeInsets.only(top: 30.0),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  'THE NETWORK',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: _height < 650 ? 25 : 30),
                ),
                Container(
                  child: Opacity(
                    opacity: 0.9,
                    child: GestureDetector(
                      child: Image.asset('assets/google2.png'),
                      onTap: () {
                        _isLoading == true ? disabledButton() : handleSignIn();
                      },
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 45, 0, 75),
                  width: _width - 50,
                ),

                //CustomLoading(),
              ],
            ),
          ),
          //Center(child: CustomLoading()),
          _isLoading == true ? CustomLoading() : Container(),
        ],
      ),
    );
  }
}
