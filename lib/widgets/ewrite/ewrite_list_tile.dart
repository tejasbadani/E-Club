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
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 145.0,
                            child: Hero(
                              tag: post.postID,
                              child: FadeInImage(
                                placeholder:
                                    Image.asset('assets/placeholder.png').image,
                                image: NetworkImage(post.imageURL),
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        post.category == 'eclub'
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Image(
                                  height: 50,
                                  width: 120,
                                  image: Image.asset('assets/badge.png').image,
                                ),
                              )
                            : Container(),
                        Positioned(
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.8,
                              child: Center(
                                child: Baseline(
                                  baselineType: TextBaseline.alphabetic,
                                  baseline: 99.0,
                                  child: Container(
                                    height: 75.0,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
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
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            post.subtitle.toUpperCase(),
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
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
