import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_e/shared/custom_loading.dart';

class UserArticle extends StatefulWidget {
  final Post post;
  UserArticle(this.post);
  @override
  State<StatefulWidget> createState() {
    return _UserArticleState();
  }
}

class _UserArticleState extends State<UserArticle> {
  TextEditingController _articleController = TextEditingController();
  FocusNode _articleFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  bool _timedOut = false;
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

  @override
  void initState() {
    _articleController.text = widget.post.article;
    overlayState = Overlay.of(context);
    super.initState();
  }

  void _updateButtonPressed() async {
    Duration time = Duration(seconds: 30);
    _showIndicator();
    await Firestore.instance
        .collection('ewrite')
        .document('not_approved')
        .collection('not_approved_docs')
        .document(widget.post.postID)
        .updateData({'article': _articleController.text}).timeout(time,
            onTimeout: () {
      _timedOut = true;
    });
    if (_timedOut) {
      _removeIndicator();
      _showToast(Colors.red, 'There seems to be a problem with the internet.');
      _timedOut = false;
    } else {
      _removeIndicator();
      _showToast(Colors.green, 'EDIT SUCCESSFUL');
    }
  }

  void _deleteButtonPressed() async {
    Duration time = Duration(seconds: 30);
    try {
      _showIndicator();
      await Firestore.instance
          .collection('ewrite')
          .document('not_approved')
          .collection('not_approved_docs')
          .document(widget.post.postID)
          .delete()
          .timeout(time, onTimeout: () {
        _timedOut = true;
      });
    } catch (e) {
      _showToast(Colors.red, 'An error occured');
    }
    if (_timedOut) {
      _removeIndicator();
      _showToast(Colors.red, 'There seems to be a problem with the internet.');
      _timedOut = false;
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      _showToast(Colors.green, 'DELETION SUCCESSFUL');
      _removeIndicator();
    }
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
                _deleteButtonPressed();
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
                  title: Text(
                    widget.post.title.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  centerTitle: true,
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        widget.post.isRejected == true
                            ? 'POST REJECTED'
                            : 'PENDING APPROVAL',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: widget.post.isRejected == true
                          ? Text(
                              widget.post.article,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 17),
                            )
                          : Form(
                              key: _formKey,
                              child: Container(
                                margin: EdgeInsets.all(15),
                                height:
                                    MediaQuery.of(context).size.height - 500,
                                alignment: Alignment.center,
                                child: EnsureVisibleWhenFocused(
                                  focusNode: _articleFocusNode,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 1000,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: '[PASTE ARTICLE HERE]',
                                    ),
                                    controller: _articleController,
                                    focusNode: _articleFocusNode,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'CANNOT SEND EMPTY ARTICLE';
                                      }
                                    },
                                    // textAlign: TextAlign.justify,
                                    // style: TextStyle(
                                    //     fontWeight: FontWeight.w300, fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    widget.post.isRejected == true
                        ? Container(
                            child: Row(
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
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 30, top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle,
                                    size: 35,
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    //Firestore.instance.collection('users').document(post.userID).collection('not_approved');
                                    if (_formKey.currentState.validate()) {
                                      _updateButtonPressed();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    size: 35,
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    _showDialog(context);
                                  },
                                )
                              ],
                            ),
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
