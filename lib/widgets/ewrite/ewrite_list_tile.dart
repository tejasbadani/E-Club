import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';

class EWriteListTile extends StatelessWidget {
  final Post post;
  EWriteListTile(this.post);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 150.0,
                            //margin: EdgeInsets.only(top: 10),
                            //padding: EdgeInsets.symmetric(vertical: 20),
                            child: Hero(
                              tag: post.postID,
                              child: FadeInImage(
                                placeholder:
                                    Image.asset('assets/e_club_1.png').image,
                                image: NetworkImage(post.imageURL),
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.8,
                          child: Center(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: 98.0,
                              child: Container(
                                height: 76.0,
                                width: MediaQuery.of(context).size.width / 1.2,
                                color: Colors.white,
                                child: Opacity(
                                  opacity: 1.0,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          post.title.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height <
                                                      650
                                                  ? 25.0
                                                  : 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        post.subtitle.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
