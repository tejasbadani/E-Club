import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberApplication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberApplicationState();
  }
}

class _MemberApplicationState extends State<MemberApplication> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  String profileURL;
  String name;
  String id;
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  SharedPreferences prefs;
  bool hasSentRequest;
  //bool _result = false;
  //int _radioValue = 0;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _departmentFocusNode = FocusNode();

  void _removeIndicator() {
    setState(() {
      _isLoading = false;
    });
    overlayEntry.remove();
  }

  void _showIndicator() {
    setState(() {
      _isLoading = true;
    });
    overlayEntry = OverlayEntry(builder: (context) => CustomLoading());
    overlayState.insert(overlayEntry);
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

  void _submit() async {
    bool _done = true;
    if (_formKey.currentState.validate()) {
      bool _to = false;
      _showIndicator();
      final data = {
        'department': _departmentController.text,
        'name': _nameController.text,
        'profileURL': profileURL,
      };

      await Firestore.instance.collection('users').document(id).updateData({
        'department': _departmentController.text,
        'hasSentRequest': true
      }).then((val) {
        prefs.setBool('hasSentRequest', true);
      }).timeout(Duration(seconds: 30), onTimeout: () {
        _showToast(Colors.red, 'Request Timed out');
        _to = true;
      });
      if (_to) {
        _to = false;
      } else {
        await Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('pending')
            .document(id)
            .setData(data)
            .timeout(Duration(seconds: 30), onTimeout: () {
          _done = false;
          _showToast(Colors.red, 'Request Timed out');
        });
        if (_done) {
          _showToast(Colors.green, 'APPLICATION SENT');
        }
      }

      _removeIndicator();
      Navigator.pop(context);
    }
  }

  Widget _submitButton() {
    return Container(
      width: 200,
      height: 40,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          if (_isLoading == true) {
            //DO NOTHING
          } else {
            _submit();
          }
        },
        child: Text(
          'SEND APPLICATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  void _getProfileURL() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      hasSentRequest = prefs.getBool('hasSentRequest');
      print(hasSentRequest);
      profileURL = prefs.getString('profileURL');
      name = prefs.getString('name');
      id = prefs.getString('id');
      print(profileURL);
    });
  }

  Widget _createCircleAvatar(String url) {
    return Center(
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
        radius: 40,
      ),
    );
  }

  Widget _createNameTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: EnsureVisibleWhenFocused(
        focusNode: _nameFocusNode,
        child: TextFormField(
          focusNode: _nameFocusNode,
          maxLength: 30,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'ENTER NAME',
          ),
          controller: _nameController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'NAME REQUIRED';
            }
          },
        ),
      ),
    );
  }

  Widget _createDepartmentTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: EnsureVisibleWhenFocused(
        focusNode: _departmentFocusNode,
        child: TextFormField(
          focusNode: _departmentFocusNode,
          maxLength: 30,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'ENTER DEPARTMENT',
          ),
          controller: _departmentController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'DEPARTMENT REQUIRED';
            }
          },
        ),
      ),
    );
  }

  // void _handleRadioValueChange(int value) {
  //   setState(() {
  //     _radioValue = value;
  //     switch (_radioValue) {
  //       case 0:
  //         _result = false;
  //         break;
  //       case 1:
  //         _result = true;
  //         break;
  //     }
  //   });
  // }

  // Widget _alumniText() {
  //   return Container(
  //     child: Text(
  //       'ARE YOU AN E CLUB ALUMNI?',
  //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
  //     ),
  //   );
  // }

  // Widget _createRadioButtons() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Radio(
  //           value: 0,
  //           groupValue: _radioValue,
  //           onChanged: _handleRadioValueChange,
  //           activeColor: Theme.of(context).primaryColor,
  //         ),
  //         Text('NO'),
  //         Radio(
  //           value: 1,
  //           activeColor: Theme.of(context).primaryColor,
  //           groupValue: _radioValue,
  //           onChanged: _handleRadioValueChange,
  //         ),
  //         Text('YES'),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    overlayState = Overlay.of(context);
    _getProfileURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: WillPopScope(
        onWillPop: () {
          print('Back button pressed!');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'AGENCY RECEPTION',
                style: TextStyle(fontSize: 15),
              ),
            ),
            body: hasSentRequest == false
                ? Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          profileURL == null
                              ? Container()
                              : _createCircleAvatar(profileURL),
                          SizedBox(height: 10.0),
                          name == null
                              ? Container()
                              : Text(
                                  name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25.0),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          _createNameTextField(),
                          _createDepartmentTextField(),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 20,
                          ),
                          _submitButton()
                        ],
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'APPLICATION ALREADY SENT OR YOU ARE ALREADY AN AGENT!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
      ),
    );
  }
}
