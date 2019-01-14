import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';

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
  bool _result = false;
  int _radioValue = 0;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _departmentFocusNode = FocusNode();

  void _submit() async {
    if (_formKey.currentState.validate()) {
      if (_result == true) {
        setState(() {
          _isLoading = true;
        });

        overlayState.insert(overlayEntry);
        final data = {
          'department': _departmentController.text,
          'name': _nameController.text,
          'profileURL': profileURL,
          'memberType': 'alumni'
        };

        await Firestore.instance.collection('users').document(id).updateData({
          'department': _departmentController.text,
          'hasSentRequest': true
        }).then((val) {
          prefs.setBool('hasSentRequest', true);
        });
        await Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('alumni')
            .document(id)
            .setData(data);
        setState(() {
          _isLoading = false;
        });

        overlayEntry.remove();
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = true;
        });

        overlayState.insert(overlayEntry);
        final data = {
          'department': _departmentController.text,
          'name': _nameController.text,
          'profileURL': profileURL,
          'memberType': 'pending'
        };

        await Firestore.instance.collection('users').document(id).updateData({
          'department': _departmentController.text,
          'hasSentRequest': true
        }).then((val) {
          prefs.setBool('hasSentRequest', true);
        });
        await Firestore.instance
            .collection('member-area')
            .document('member-list')
            .collection('pending')
            .document(id)
            .setData(data);
        setState(() {
          _isLoading = false;
        });

        overlayEntry.remove();
        Navigator.pop(context);
      }
    }
  }

  Widget _submitButton() {
    return Container(
      width: 300,
      height: 50,
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
            fontSize: 20,
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
    print('EXE');
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = false;
          break;
        case 1:
          _result = true;
          break;
      }
    });
  }

  Widget _alumniText() {
    return Container(
      child: Text(
        'ARE YOU AN E CLUB ALUMNI?',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
      ),
    );
  }

  Widget _createRadioButtons() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
            activeColor: Theme.of(context).primaryColor,
          ),
          Text('NO'),
          Radio(
            value: 1,
            activeColor: Theme.of(context).primaryColor,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text('YES'),
        ],
      ),
    );
  }

  @override
  void initState() {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) => CustomLoading());
    _getProfileURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MEMBER RECEPTION'),
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
                                fontWeight: FontWeight.w300, fontSize: 25.0),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    _createNameTextField(),
                    _createDepartmentTextField(),
                    SizedBox(height: 20),
                    _alumniText(),
                    _createRadioButtons(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton()
                  ],
                ),
              ),
            )
          : Center(
              child: Text('REQUEST ALREADY SENT'),
            ),
    );
  }
}
