import 'package:flutter/material.dart';
import 'package:project_e/model/post_ewrite.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void _updateButtonPressed() {
    Firestore.instance
        .collection('ewrite')
        .document('not_approved')
        .collection('not_approved_docs')
        .document(widget.post.postID)
        .updateData({'article': _articleController.text}).then((val) {
      Fluttertoast.showToast(
          msg: 'EDIT SUCCESS ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          backgroundColor: Colors.green);
    });
  }

  void _deleteButtonPressed() {
    //TODO Show prompt first
    Firestore.instance
        .collection('ewrite')
        .document('not_approved')
        .collection('not_approved_docs')
        .document(widget.post.postID)
        .delete()
        .then((val) {
      Fluttertoast.showToast(
          msg: 'DELETE SUCCESS ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _articleController.text = widget.post.article;
    super.initState();
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
                      widget.post.isRejected == true
                          ? 'POST REJECTED'
                          : 'PENDING APPROVAL',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
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
                      ? Container()
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
                                  _deleteButtonPressed();
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
    );
  }
}
