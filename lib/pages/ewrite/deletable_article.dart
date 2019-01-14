import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';

class DeleteArticle extends StatefulWidget {
  final Post post;
  //TODO
  DeleteArticle(this.post);
  @override
  State<StatefulWidget> createState() {
    return _DeleteArticleState();
  }
}

class _DeleteArticleState extends State<DeleteArticle> {
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  @override
  void initState() {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) => CustomLoading());
    super.initState();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DELETE?'),
          content: Text('Are you sure you want to delete the article ?'),
          actions: <Widget>[
            RaisedButton(
              child: Text('YES'),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Firestore.instance
                    .collection('ewrite')
                    .document('approved')
                    .collection('approved_docs')
                    .document(widget.post.postID)
                    .delete();
                Firestore.instance
                    .collection('ewrite')
                    .document(widget.post.category)
                    .collection('approved')
                    .document(widget.post.postID)
                    .delete()
                    .whenComplete(() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('NO'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
      context: context,
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
                  widget.post.title.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                background: Hero(
                    tag: widget.post.postID,
                    child: Opacity(
                      opacity: 0.8,
                      child: FadeInImage(
                        image: NetworkImage(widget.post.imageURL),
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
                      'BY ${widget.post.subtitle.toUpperCase()}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'CATEGORY : ${widget.post.category.toUpperCase()}',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(
                      widget.post.article,
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_sweep,
                            size: 35,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            _showDialog(context);
                          },
                        ),
                      ),
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
