import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateCalendarEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateCalendarEventState();
  }
}

class _CreateCalendarEventState extends State<CreateCalendarEvent> {
  String _datePickerValue;
  String _secondValue;
  bool _didNotChooseDate = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _descriptionController = TextEditingController();
  FocusNode _descriptionFocusNode = FocusNode();
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  bool _timedOut = false;
  @override
  void initState() {
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
    if (_formKey.currentState.validate() && _datePickerValue != null) {
      _showIndicator();
      final data = {
        'completed': false,
        'date': _datePickerValue,
        'accurate': _secondValue,
        'description': _descriptionController.text,
        'name': _nameController.text
      };
      Duration time = Duration(seconds: 30);
      await Firestore.instance
          .collection('calendar-events')
          .document()
          .setData(data)
          .timeout(time, onTimeout: () {
        _timedOut = true;
      });
      if (_timedOut) {
        _showToast(
            Colors.red, 'There seems to be a problem with the connection');
        _removeIndicator();
        _timedOut = false;
      } else {
        _showToast(Colors.green, 'ADDED EVENT');
        Navigator.pop(context);
        _removeIndicator();
      }
    } else if (_datePickerValue == null) {
      setState(() {
        _didNotChooseDate = true;
      });
    }
  }

  void _datePicker(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2020),
    );

    if (picked != null)
      setState(() {
        _didNotChooseDate = false;
        String formattedDate = DateFormat('EEE d MMM').format(picked);
        String formattedDate2 = DateFormat(' MM.d.yyyy ').format(picked);
        print('DONE $formattedDate');
        _datePickerValue = formattedDate;
        _secondValue = formattedDate2;
      });
  }

  Widget _createDatePickerButton(BuildContext context) {
    return FlatButton(
      child: Text(
        'CHOOSE DATE',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        if (_isLoading == false) {
          _datePicker(context);
        }
      },
    );
  }

  Widget _createNameTextField() {
    return Container(
      margin: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: EnsureVisibleWhenFocused(
        focusNode: _nameFocusNode,
        child: TextFormField(
          enabled: !_isLoading,
          focusNode: _nameFocusNode,
          maxLength: 50,
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

  Widget _createDescriptionTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          focusNode: _descriptionFocusNode,
          enabled: !_isLoading,
          maxLength: 100,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'ENTER DESCRIPTION',
          ),
          controller: _descriptionController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'DESCRIPTION REQUIRED';
            }
          },
        ),
      ),
    );
  }

  Widget _createTimeText() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        '${_datePickerValue.toUpperCase()}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _createSubmitButton() {
    return Container(
      width: 200,
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
          'ADD EVENT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
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
            title: Text('Enter new calendar event'),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _createNameTextField(),
                  _createDescriptionTextField(),
                  Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.grey),
                    child: Builder(
                        builder: (context) => _createDatePickerButton(context)),
                  ),
                  _datePickerValue != null ? _createTimeText() : Container(),
                  _didNotChooseDate == true
                      ? Text(
                          'DATE REQUIRED',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  _createSubmitButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
