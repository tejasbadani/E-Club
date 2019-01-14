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
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _articleController.text = widget.post.article;
    super.initState();
  }

  void _isLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomLoading();
      },
      context: context,
    );
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
        Firestore.instance
            .collection('ewrite')
            .document('not_approved')
            .collection('not_approved_docs')
            .document(widget.post.postID)
            .delete()
            .then((val) {});
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
        Firestore.instance
            .collection('ewrite')
            .document(widget.post.category)
            .collection('approved')
            .document(widget.post.postID)
            .setData(data);

        Firestore.instance
            .collection('ewrite')
            .document('approved')
            .collection('approved_docs')
            .document(widget.post.postID)
            .setData(data)
              ..then((err) {
                Navigator.pop(context);
                Navigator.pop(context);
              }).catchError(() {
                print('ERROR OCCURED');
              });
      } else {
        print('DOESNT EXIST ANYMORE');
      }
    }).whenComplete(() {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Oops. Seems like the another admin has verified the post.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });
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
        Firestore.instance
            .collection('ewrite')
            .document('not_approved')
            .collection('not_approved_docs')
            .document(widget.post.postID)
            .updateData({'rejected': true}).then((err) {
          Navigator.pop(context);
          Navigator.pop(context);
        }).catchError(() {
          print('ERROR OCCURED');
        });
      } else {
        print('DOESNT EXIST ANYMORE');
      }
    }).whenComplete(() {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Oops. Seems like the another admin has verified the post.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });
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
                            _isLoading(context);
                            //Firestore.instance.collection('users').document(post.userID).collection('not_approved');
                            if (_formKey.currentState.validate()) {
                              _approvedArticle();
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
                            _isLoading(context);
                            _rejectedArticle();
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
    );
  }
}
