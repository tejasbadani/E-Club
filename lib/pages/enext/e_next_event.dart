import 'package:flutter/material.dart';
import 'package:project_e/model/event_list.dart';

class ENextEvent extends StatelessWidget {
  final Event event;
  ENextEvent({@required this.event});
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
                  image: NetworkImage(event.image),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  event.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                  ),
                ),
              ),
              Container(
                child: Text(
                  event.article,
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
