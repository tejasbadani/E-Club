import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApprovalArticle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApprovalArticleState();
  }

  final Post post;
  ApprovalArticle(this.post);
}

class _ApprovalArticleState extends State<ApprovalArticle> {
  TextEditingController _articleController = TextEditingController();
  FocusNode _articleFocusNode = FocusNode();
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  bool _isExists = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    overlayState = Overlay.of(context);
    _articleController.text = widget.post.article;
    super.initState();
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

  void _approvedArticle() {
    final documentRef = Firestore.instance
        .collection('ewrite')
        .document('not_approved')
        .collection('not_approved_docs')
        .document(widget.post.postID);
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(documentRef);
      if (postSnapshot.exists) {
        _isExists = true;
        try {
          final Map<String, dynamic> data = {
            'article': _articleController.text,
            'title': widget.post.title,
            'date': widget.post.date,
            'author': widget.post.subtitle,
            'imageURL': widget.post.imageURL,
            'category': widget.post.category,
            'userID': widget.post.userID,
            'rejected': false
          };
          bool _to = false;
          await Firestore.instance
              .collection('ewrite')
              .document('not_approved')
              .collection('not_approved_docs')
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
                .setData(data)
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
                  .document('approved')
                  .collection('approved_docs')
                  .document(widget.post.postID)
                  .setData(data)
                  .timeout(Duration(seconds: 30), onTimeout: () {
                _showToast(Colors.red, 'Request Timed out');
                _removeIndicator();
              });
            }
          }
        } catch (e) {
          _showToast(Colors.red, 'An error occured');
        }
      } else {
        print('DOESNT EXIST ANYMORE');
      }
    }).whenComplete(() {
      if (_isExists) {
        _showToast(Colors.green, 'APPROVED');
        _removeIndicator();
        Navigator.pop(context);
      } else {
        _showToast(Colors.red,
            'Oops. Seems like the another admin has verified the post.');
        _removeIndicator();
        Navigator.pop(context);
      }
    });
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

  void _rejectedArticle() {
    final documentRef = Firestore.instance
        .collection('ewrite')
        .document('not_approved')
        .collection('not_approved_docs')
        .document(widget.post.postID);
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(documentRef);
      if (postSnapshot.exists) {
        _isExists = true;
        try {
          await Firestore.instance
              .collection('ewrite')
              .document('not_approved')
              .collection('not_approved_docs')
              .document(widget.post.postID)
              .updateData({'rejected': true}).catchError(() {
            print('ERROR OCCURED');
          }).timeout(Duration(seconds: 30), onTimeout: () {
            _showToast(Colors.red, 'Request Timed out');
            _removeIndicator();
          });
        } catch (e) {
          _showToast(Colors.red, 'An error occured');
        }
      } else {
        print('DOESNT EXIST ANYMORE');
      }
    }).whenComplete(() {
      if (_isExists) {
        _showToast(Colors.red, 'REJECTED');
        _removeIndicator();
        Navigator.pop(context);
      } else {
        _showToast(Colors.red,
            'Oops. Seems like the another admin has verified the post.');
        _removeIndicator();
        Navigator.pop(context);
      }
    });
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
                    textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: Text(
                        widget.post.category == 'eclub'
                            ? 'CATEGORY : ELS'
                            : 'CATEGORY : ${widget.post.category.toUpperCase()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height - 500,
                        alignment: Alignment.center,
                        child: EnsureVisibleWhenFocused(
                          focusNode: _articleFocusNode,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            maxLines: 1000,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: '[PASTE ARTICLE HERE]',
                            ),
                            controller: _articleController,
                            focusNode: _articleFocusNode,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'CANNOT APPROVE EMPTY ARTICLE';
                              }
                            },
                            // textAlign: TextAlign.justify,
                            // style: TextStyle(
                            //     fontWeight: FontWeight.w300, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    Container(
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
                                if (_isLoading == false) {
                                  _showIndicator();
                                  _approvedArticle();
                                }
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
                              if (_isLoading == false) {
                                _showIndicator();
                                _rejectedArticle();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
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
