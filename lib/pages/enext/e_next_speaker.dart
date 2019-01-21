import 'package:flutter/material.dart';
import 'package:project_e/model/speaker_list.dart';
import 'package:url_launcher/url_launcher.dart';

class ENextSpeaker extends StatelessWidget {
  final Speaker speaker;
  ENextSpeaker({@required this.speaker});
  void _launchURlInstagram() async {
    final String url = speaker.instagramURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLLinkedin() async {
    final String url = speaker.linkedInURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLFacebook() async {
    final String url = speaker.facebookURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  Widget _buildContactButtons() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  print('INSTAGRAM');
                  _launchURlInstagram();
                },
                child: Image(
                  image: Image.asset('assets/instagram.png').image,
                ),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  _launchURLLinkedin();
                  print('LINKEDIN');
                },
                child: Image(
                  image: Image.asset('assets/linkedin.png').image,
                ),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  _launchURLFacebook();
                  print('FACEBOOK');
                },
                child: Image(
                  image: Image.asset('assets/facebook.png').image,
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 250),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.white, width: 3),
                        ),
                      ),
                      margin: EdgeInsets.all(20),
                      child: CircleAvatar(
                        //backgroundImage: NetworkImage(event.image),

                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: NetworkImage(speaker.image),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: Text(
                        speaker.name.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 250,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(''),
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: <Widget>[
                      _buildContactButtons(),
                      Container(
                        child: Text(
                          speaker.article,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        margin: EdgeInsets.only(
                            bottom: 30, left: 20, right: 20, top: 15),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
