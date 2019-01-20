import 'package:flutter/material.dart';
import 'package:project_e/widgets/enext/event_card.dart';
import 'package:project_e/model/speaker_list.dart';
import 'package:project_e/model/event_list.dart';
import 'package:project_e/widgets/enext/speaker_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import './e_next_event.dart';
import './e_next_speaker.dart';

class Enext extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnextState();
  }
}

class _EnextState extends State<Enext> {
  final List<Event> events = [];
  final List<Speaker> speakers = [];
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

  List<Container> _buildGridTileListSpeaker(int count, data) {
    return List<Container>.generate(
      count,
      (int index) {
        final currentData = data.data.documents[index];
        final Speaker currentSpeaker = Speaker(
          id: currentData.documentID,
          image: currentData['imageURL'],
          name: currentData['title'],
          article: currentData['article'],
          instagramURL: currentData['instagram'],
          facebookURL: currentData['facebook'],
          linkedInURL: currentData['linkedin'],
        );
        speakers.add(currentSpeaker);
        return Container(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ENextSpeaker(speaker: currentSpeaker)));
            },
            child: SpeakerCard(
              speaker: currentSpeaker,
            ),
          ),
        );
      },
    );
  }

  void _launchURl() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'E NEXT',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '1st , 2nd March 2019',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 30, bottom: 10, left: 30),
            child: Text(
              'EVENTS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 150,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('enext')
                        .document('events')
                        .collection('event_list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text('NO EVENTS YET'),
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
                          child: Text('NO BLOGS'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 30),
            child: Text(
              'SPEAKERS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 150,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('enext')
                        .document('speakers')
                        .collection('speaker_list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text('NO SPEAKERS YET'),
                          );
                        }
                        return GridView.extent(
                          scrollDirection: Axis.horizontal,
                          children: _buildGridTileListSpeaker(
                              snapshot.data.documents.length, snapshot),
                          maxCrossAxisExtent: 150,
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CupertinoActivityIndicator();
                      }

                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: Text('NOTHING HERE'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 200,
            height: 50,
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: _launchURl,
              child: Text(
                'REGISTER NOW',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
        ],
      ),
    );
  }
}
