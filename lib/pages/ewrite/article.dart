import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';

class Article extends StatelessWidget {
  final Post post;
  Article(this.post);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  post.title.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                background: Hero(
                    tag: post.postID,
                    child: Opacity(
                      opacity: 0.8,
                      child: FadeInImage(
                        image: NetworkImage(post.imageURL),
                        height: 300.0,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/e_club_1.png'),
                      ),
                    )),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    child: Text(
                      'BY ${post.subtitle.toUpperCase()}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(
                      post.article,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
                    ),
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
