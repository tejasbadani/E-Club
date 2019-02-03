import 'package:flutter/material.dart';
import 'package:project_e/model/speaker_list.dart';

class SpeakerCard extends StatelessWidget {
  final Speaker speaker;
  SpeakerCard({@required this.speaker});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage(
            height: 100,
            width: 95,
            placeholder: Image.asset('assets/network.png').image,
            image: NetworkImage(speaker.image),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(speaker.name.toUpperCase()),
        )
      ],
    );
  }
}
