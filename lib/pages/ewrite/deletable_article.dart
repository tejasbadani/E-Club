import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteArticle extends StatefulWidget {
  final Post post;
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
    super.initState();
  }

  void _removeIndicator() {
    setState(() {
      _isLoading = false;
    });
    overlayEntry.remove();
  }

  void _showIndicator() {
    setState(() {
      _isLoading = true;
    });
    overlayEntry = OverlayEntry(builder: (context) => CustomLoading());
    overlayState.insert(overlayEntry);
  }

  void _showToast(Color color, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        textColor: Colors.white,
        backgroundColor: color);
  }

  void _delete() async {
    try {
      _showIndicator();
      bool _to = false;
      await Firestore.instance
          .collection('ewrite')
          .document('approved')
          .collection('approved_docs')
          .document(widget.post.postID)
          .delete()
          .timeout(Duration(seconds: 30), onTimeout: () {
        _showToast(Colors.red, 'Request Timed out');
        _to = true;
        _removeIndicator();
      });
      if (_to) {
        _to = false;
      } else {
        await Firestore.instance
            .collection('ewrite')
            .document(widget.post.category)
            .collection('approved')
            .document(widget.post.postID)
            .delete()
            .timeout(Duration(seconds: 30), onTimeout: () {
          _showToast(Colors.red, 'Request Timed out');
          _to = true;
          _removeIndicator();
        });
        if (_to == false) {
          _showToast(Colors.red, 'DELETED');
        }
      }
    } catch (e) {
      _removeIndicator();
      print(e);
      _showToast(Colors.red, 'An error occured.');
    }
    _removeIndicator();
    Navigator.pop(context);
    Navigator.pop(context);
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
                _delete();
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
    return AbsorbPointer(
      absorbing: _isLoading,
      child: WillPopScope(
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
                  centerTitle: true,
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
                          placeholder: AssetImage('assets/placeholder2.png'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'CATEGORY : ${widget.post.category.toUpperCase()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        widget.post.article,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 17),
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
      ),
    );
  }
}
