import 'package:flutter/material.dart';
import 'package:project_e/model/event_list.dart';
import 'package:url_launcher/url_launcher.dart';

class ENextEvent extends StatelessWidget {
  final Event event;
  ENextEvent({@required this.event});
  void _launchURlInstagram() async {
    const url = 'https://www.instagram.com/psgtech_eclub/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLLinkedin() async {
    const url = 'https://www.linkedin.com/school/psgtecheclub/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch');
    }
  }

  void _launchURLFacebook() async {
    const url = 'https://www.facebook.com/psgtecheclub/';
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

  Widget _createTop() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 70,
        ),
        Container(
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(color: Colors.white, width: 3),
            ),
          ),
          margin: EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundImage: NetworkImage(event.image),
            radius: 50,
            backgroundColor: Colors.blue,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 25),
          child: Text(
            event.name.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 21, color: Colors.white),
          ),
        ),
      ],
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
              flexibleSpace: FlexibleSpaceBar(
                background: _createTop(),
              ),
              // bottom: PreferredSize(
              //   preferredSize: Size(MediaQuery.of(context).size.width, 250),
              //   child: _createTop(),
              // ),
              expandedHeight: 250,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: <Widget>[
                      _buildContactButtons(),
                      Container(
                        child: Text(
                          event.article,
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
//     Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         //title: Text('E NEXT'),
//         bottom: PreferredSize(
//             preferredSize: Size(MediaQuery.of(context).size.width, 250),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   decoration: ShapeDecoration(
//                     shape: CircleBorder(
//                       side: BorderSide(color: Colors.white, width: 3),
//                     ),
//                   ),
//                   margin: EdgeInsets.all(20),
//                   child: CircleAvatar(
//                     //backgroundImage: NetworkImage(event.image),
//                     radius: 50,
//                     backgroundColor: Colors.blue,
//                     child: Image(
//                       image: NetworkImage(event.image),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 25),
//                   child: Text(
//                     event.name,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 21,
//                         color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.only(top: 30),
//           child: Column(
//             children: <Widget>[
//               // ClipRRect(
//               //   borderRadius: BorderRadius.circular(8.0),
//               //   child: FadeInImage(
//               //     height: 100,
//               //     width: 95,
//               //     placeholder: Image.asset('assets/e_club_1.png').image,
//               //     image: NetworkImage(event.image),
//               //     fit: BoxFit.cover,
//               //   ),
//               // ),
//               // Container(
//               //   margin: EdgeInsets.symmetric(vertical: 10),
//               //   child: Text(
//               //     event.name,
//               //     style: TextStyle(
//               //       fontWeight: FontWeight.w500,
//               //       fontSize: 21,
//               //     ),
//               //   ),
//               // ),
//               Row(
//                 children: <Widget>[],
//               ),
//               Container(
//                 child: Text(
//                   event.article,
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w300,
//                     fontSize: 16,
//                   ),
//                 ),
//                 margin:
//                     EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 15),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
