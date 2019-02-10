import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewVoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewVoiceState();
  }
}

class _NewVoiceState extends State<NewVoice> {
  TextEditingController _voiceController = TextEditingController();
  String profileURL;
  String name;
  String userID;

  final _formKey = GlobalKey<FormState>();
  final FocusNode _voiceFocusNode = FocusNode();

  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  bool _timedOut = false;
  @override
  void initState() {
    _getProfileURL();
    overlayState = Overlay.of(context);
    super.initState();
  }

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

  Widget _createVoiceField() {
    return Container(
      height: 200,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: EnsureVisibleWhenFocused(
        focusNode: _voiceFocusNode,
        child: TextFormField(
          enabled: !_isLoading,
          focusNode: _voiceFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLines: 30,
          maxLength: 500,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: '[TYPE SOMETHING]',
          ),
          controller: _voiceController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'VOICE REQUIRED';
            }
          },
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _showIndicator();
      DateTime now = DateTime.now();
      int seconds = now.millisecondsSinceEpoch;
      String formattedDate = DateFormat('KK:mm a d/MM').format(now);
      Duration time = Duration(seconds: 30);

      final data = {
        'message': _voiceController.text,
        'username': name,
        'userID': userID,
        'profileURL': profileURL,
        'date': formattedDate,
        'epoch':seconds
      };
      await Firestore.instance
          .collection('evoice')
          .document()
          .setData(data)
          .timeout(time, onTimeout: () {
        _timedOut = true;
      });
      if (!_timedOut) {
        Navigator.pop(context);
        _removeIndicator();
      } else {
        _removeIndicator();
        _showToast(
            Colors.red, 'There seems to be a problem with the connection.');
        _timedOut = false;
      }
    }
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

  Widget _submitButton() {
    return Container(
      width: 150,
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
          'POST',
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileURL = prefs.getString('profileURL');
      name = prefs.getString('name');
      userID = prefs.getString('id');
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
              'NEW MESSAGE',
              style: TextStyle(fontSize: 15),
            ),
          ),
          body: Form(
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
                  _createVoiceField(),
                  SizedBox(
                    height: 50,
                  ),
                  _submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
