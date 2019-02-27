import 'package:flutter/material.dart';
import 'package:project_e/widgets/enext/event_card.dart';
import 'package:project_e/model/speaker_list.dart';
import 'package:project_e/model/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import './e_next_event.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Enext extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnextState();
  }
}

class _EnextState extends State<Enext> {
  final List<Event> events = [];
  final List<Speaker> speakers = [];
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneNode = FocusNode();
  String _userName;
  String _profileURL;
  String _id;
  void _getData() async {
    prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('name');
    _profileURL = prefs.getString('profileURL');
    _id = prefs.getString('id');
  }

  List<Container> _buildGridTileListEvent(int count, data) {
    return List<Container>.generate(
      count,
      (int index) {
        final currentData = data.data.documents[index];
        final Event currentEvent = Event(
          id: currentData.documentID,
          image: currentData['imageURL'],
          name: currentData['title'],
          article: currentData['article'],
        );
        events.add(currentEvent);
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ENextEvent(event: currentEvent)));
            },
            child: EventCard(
              event: currentEvent,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  // void _launchURl() async {
  //   const url = 'https://flutter.io';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch');
  //   }
  // }

  void _showToast(Color color, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        textColor: Colors.white,
        backgroundColor: color);
  }

  Widget _createPhoneNumberTextField() {
    return Container(
      margin: EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 20),
      child: EnsureVisibleWhenFocused(
        focusNode: _phoneNode,
        child: TextFormField(
          focusNode: _phoneNode,
          //maxLength: 30,

          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            hintText: 'ENTER PHONE NUMBER',
          ),
          controller: _phoneController,
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return 'PHONE NUMBER INCORRECT';
            }
          },
        ),
      ),
    );
  }

  void _submit() async {
    bool _done = true;
    if (_formKey.currentState.validate()) {
      final data = {
        'number': _phoneController.text,
        'name': _userName,
        'profileURL': _profileURL
      };
      Duration time = Duration(seconds: 30);
      await Firestore.instance
          .collection('registrations')
          .document(_id)
          .setData(data)
          .timeout(time, onTimeout: () {
        _done = false;
      });
      if (_done) {
        setState(() {
          _phoneController.text = '';
        });
        _showToast(Colors.green, 'REGISTRATION DONE');
      } else {
        _showToast(Colors.red, 'REQUEST TIMED OUT');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(
              'WANT TO JOIN?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'REGISTER NOW!\nWE WILL CONTACT YOU.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 30, bottom: 10, left: 30),
            child: Text(
              'WHY JOIN THE NETWORK?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 150,
                  child: StreamBuilder(
                    stream:
                        Firestore.instance.collection('network').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text('COMING SOON'),
                          );
                        }
                        return GridView.extent(
                          scrollDirection: Axis.horizontal,
                          children: _buildGridTileListEvent(
                              snapshot.data.documents.length, snapshot),
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 3,
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CupertinoActivityIndicator();
                      }

                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: Text('NOTHING HERE YET'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   margin: EdgeInsets.only(top: 10, bottom: 10, left: 30),
          //   child: Text(
          //     'WHY JOIN THE NETWORK?',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          //   ),
          // ),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //       child: Container(
          //         height: 150,
          //         child: StreamBuilder(
          //           stream:
          //               Firestore.instance.collection('network').snapshots(),
          //           builder: (context, snapshot) {
          //             if (snapshot.hasData) {
          //               if (snapshot.data.documents.length == 0) {
          //                 return Center(
          //                   child: Text('COMING SOON'),
          //                 );
          //               }
          //               return GridView.extent(
          //                 scrollDirection: Axis.horizontal,
          //                 children: _buildGridTileListSpeaker(
          //                     snapshot.data.documents.length, snapshot),
          //                 maxCrossAxisExtent: 150,
          //               );
          //             }
          //             if (snapshot.connectionState != ConnectionState.done) {
          //               return CupertinoActivityIndicator();
          //             }

          //             if (!snapshot.hasData &&
          //                 snapshot.connectionState == ConnectionState.done) {
          //               return Center(
          //                 child: Text('NOTHING HERE YET'),
          //               );
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Form(
            child: _createPhoneNumberTextField(),
            key: _formKey,
          ),
          Container(
            width: 175,
            height: 35,
            margin: EdgeInsets.only(top: 5, bottom: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: _submit,
              child: Text(
                'REGISTER NOW',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
        ],
      ),
    );
  }
}
