import 'package:flutter/material.dart';
import 'package:project_e/model/event_list.dart';

class EventCard extends StatelessWidget {
  final Event event;
  EventCard({@required this.event});
  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(event.name.toUpperCase()),
        )
      ],
    );
  }
}
