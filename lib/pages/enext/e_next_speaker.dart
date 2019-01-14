import 'package:flutter/material.dart';
import 'package:project_e/model/speaker_list.dart';

class ENextSpeaker extends StatelessWidget {
  final Speaker speaker;
  ENextSpeaker({@required this.speaker});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E NEXT'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage(
                  height: 100,
                  width: 95,
                  placeholder: Image.asset('assets/e_club_1.png').image,
                  image: NetworkImage(speaker.image),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  speaker.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                  ),
                ),
              ),
              Container(
                child: Text(
                  speaker.article,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
                margin:
                    EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
