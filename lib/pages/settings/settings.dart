import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  SharedPreferences prefs;
  String _id, _profileURL, _name;
  bool _isMember;
  String _memberType;
  TextEditingController _userNameController = TextEditingController();
  FocusNode _usernameFocus = FocusNode();
  TextEditingController _departmentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode _departmentFocus = FocusNode();
  String _department;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id');
      _profileURL = prefs.getString('profileURL');
      _name = prefs.getString('name');
      _isMember = prefs.getBool('isMember');
      _memberType = prefs.getString('memberType');
      _userNameController.text = _name.toUpperCase();
    });
    final data =
        await Firestore.instance.collection('users').document(_id).get();
    if (data != null) {
      final dataArray = data.data;
      setState(() {
        _departmentController.text = dataArray['department'].toUpperCase();
        _department = dataArray['department'];
      });
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Widget _createProfileImage() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        backgroundImage: NetworkImage(_profileURL),
        radius: 40,
      ),
    );
  }

  Widget _createNameTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 7, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              'USERNAME',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          EnsureVisibleWhenFocused(
            focusNode: _usernameFocus,
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              validator: (String val) {
                if (val.isEmpty) {
                  return 'USERNAME NEEDED';
                }
              },
              focusNode: _usernameFocus,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (String value) {
                final str = _userNameController.text;
                Duration time = Duration(seconds: 30);
                if (_formKey.currentState.validate()) {
                  Firestore.instance
                      .collection('users')
                      .document(_id)
                      .updateData({'name': str}).timeout(time, onTimeout: () {
                    _showToast(Colors.red, 'Request timed out');
                    setState(() {
                      _userNameController.text = _name.toUpperCase();
                    });
                  }).whenComplete(() {
                    _showToast(Colors.green, 'USERNAME CHANGE SUCCESSFUL');
                    prefs.setString('name', _userNameController.text);
                    _name = _userNameController.text;
                  });

                  if (_memberType != 'none' && _memberType != null) {
                    Firestore.instance
                        .collection('member-area')
                        .document('member-list')
                        .collection(_memberType)
                        .document(_id)
                        .updateData({'name': str}).timeout(time, onTimeout: () {
                      _showToast(Colors.red, 'Request timed out');
                    });
                  }
                }
              },
              controller: _userNameController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(Color color, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        textColor: Colors.white,
        backgroundColor: color);
  }

  Widget _createDepartmentTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 7, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              'DEPARTMENT',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          EnsureVisibleWhenFocused(
            focusNode: _departmentFocus,
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              validator: (String val) {
                if (val.isEmpty) {
                  return 'DEPARTMENT NEEDED';
                }
              },
              focusNode: _departmentFocus,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (String value) {
                final str = _departmentController.text;
                Duration time = Duration(seconds: 30);
                if (_formKey.currentState.validate()) {
                  Firestore.instance
                      .collection('users')
                      .document(_id)
                      .updateData({'department': str}).timeout(time,
                          onTimeout: () {
                    _departmentController.text = _department.toUpperCase();
                    _showToast(Colors.red, 'Request timed out');
                  }).whenComplete(() {
                    _showToast(Colors.green, 'DEPARTMENT CHANGED SUCCESSFULLY');
                    _department = _departmentController.text;
                  });

                  if (_memberType != 'none' && _memberType != null) {
                    Firestore.instance
                        .collection('member-area')
                        .document('member-list')
                        .collection(_memberType)
                        .document(_id)
                        .updateData({'department': str}).timeout(time,
                            onTimeout: () {
                      _showToast(Colors.red, 'Request timed out');
                    });
                  }
                }
                //Validate here
                //Change department in member list too
              },
              controller: _departmentController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogLogout(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('LOG OUT?'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            RaisedButton(
              child: Text('YES'),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
                logOut();
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('NO'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  void _showLeaveMember(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Leave E CLUB?'),
          content: Text('Are you sure you want to Resign as an E CLUB member?'),
          actions: <Widget>[
            RaisedButton(
              child: Text('YES'),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
                _leaveEClub();
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('NO'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 50,
      color: Color(0xffDCDCDC),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        child: Text(
          'LOG OUT',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.red,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          _showDialogLogout(context);
        },
      ),
    );
  }

  void _leaveEClub() {
    setState(() {
      _isMember = false;
    });

    Firestore.instance.collection('users').document(_id).updateData({
      'isMember': false,
      'memberType': 'none',
      'hasSentRequest': false,
      'isMemberAdmin': false
    }).then((val) {
      _isMember = false;
      _memberType = 'none';

      prefs.setBool('isMember', false);
      prefs.setString('memberType', 'none');
      prefs.setBool('hasSentRequest', false);
      prefs.setBool('isMemberAdmin', false);
    });
  }

  Widget _buildLeaveEClub() {
    return Container(
      height: 50,
      color: Color(0xffDCDCDC),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        child: Text(
          'RESIGN AS MEMBER',
          style: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.red, fontSize: 18),
        ),
        onPressed: () {
          _showLeaveMember(context);
        },
      ),
    );
  }

  Widget _buildContactText() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        'CONTACT US',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print('INSTAGRAM');
              _launchURlInstagram();
            },
            child: Image(
              image: Image.asset('assets/instagram.png').image,
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURLLinkedin();
              print('LINKEDIN');
            },
            child: Image(
              image: Image.asset('assets/linkedin.png').image,
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURLFacebook();
              print('FACEBOOK');
            },
            child: Image(
              image: Image.asset('assets/facebook.png').image,
            ),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, '/Intro');
  }

  void _launchURlInstagram() async {
    const url = 'https://www.instagram.com/psgtech_eclub/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLLinkedin() async {
    const url = 'https://www.linkedin.com/school/psgtecheclub/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLFacebook() async {
    const url = 'https://www.facebook.com/psgtecheclub/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _id != null
        ? SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _createProfileImage(),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'EDIT BIO',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                    ),
                  ),
                  _createNameTextField(),
                  _createDepartmentTextField(),
                  _buildContactText(),
                  _buildContactButtons(),
                  _isMember == true ? _buildLeaveEClub() : Container(),
                  _buildLogoutButton(),
                  //Contact us , log out , be a member no more
                ],
              ),
            ),
          )
        : Container();
  }
}
