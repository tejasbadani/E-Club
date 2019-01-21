import 'package:flutter/material.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_e/shared/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateArticle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateArticleState();
  }
}

class _CreateArticleState extends State<CreateArticle> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _articleFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  String name, id, photoURL;
  File _image;
  bool _timedOut = false;
  bool _timedOut2 = false;
  SharedPreferences prefs;
  String _result = 'blogs';
  int _radioValue = 0;
  bool _hasNotChosen = false;
  bool _isLoading = false;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = 'blogs';
          break;
        case 1:
          _result = 'eclub';
          break;
      }
    });
  }

  Widget _createRadioButtons() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
            activeColor: Theme.of(context).primaryColor,
          ),
          Text('BLOGS'),
          Radio(
            value: 1,
            activeColor: Theme.of(context).primaryColor,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text('E CLUB'),
        ],
      ),
    );
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 16.0,
      ratioY: 9.0,
    );
    setState(() {
      _image = croppedFile;
      _hasNotChosen = false;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    _cropImage(image);
  }

  Widget _createImageButton() {
    return Container(
      child: IconButton(
        icon: Icon(Icons.camera_enhance),
        onPressed: () {
          getImage();
        },
      ),
    );
  }

  Widget _createTitleTextField() {
    return Container(
      margin: EdgeInsets.all(20),
      child: EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          maxLength: 50,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'ENTER TITLE',
          ),
          controller: _titleController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'TITLE REQUIRED';
            }
          },
        ),
      ),
    );
  }

  Widget _createArticleTextField() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 - 100,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: EnsureVisibleWhenFocused(
        focusNode: _articleFocusNode,
        child: TextFormField(
          focusNode: _articleFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLines: 1000,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: '[PASTE ARTICLE HERE]',
          ),
          controller: _articleController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'ARTICLE REQUIRED';
            }
          },
        ),
      ),
    );
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

  Widget _submitButton() {
    return Container(
      width: 200,
      height: 50,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          if (_isLoading == true) {
            //DO NOTHING
          } else {
            _submit();
          }
        },
        child: Text(
          'SUBMIT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState.validate() && _image != null) {
      _showIndicator();
      prefs = await SharedPreferences.getInstance();
      name = prefs.getString('name');
      id = prefs.getString('id');
      photoURL = prefs.getString('photoURL');
      DateTime now = DateTime.now();
      String formattedDate = DateFormat(' MM.d KK:mm a ').format(now);
      final String url = await _pickSaveImage();
      print('URL IS $url');
      if (url != ' ') {
        print('URL $url');
        final Map<String, dynamic> data = {
          'article': _articleController.text,
          'title': _titleController.text,
          'date': formattedDate,
          'author': name,
          'imageURL': url,
          'category': _result,
          'userID': id,
          'rejected': false
        };
        Duration time = Duration(seconds: 30);
        await Firestore.instance
            .collection('ewrite')
            .document('not_approved')
            .collection('not_approved_docs')
            .document()
            .setData(data)
            .timeout(time, onTimeout: () {
              _timedOut2 = true;
              _showToast(Colors.red, 'Request timed out. Please try again');

              return null;
            })
            .whenComplete(() {
              print('BYE');
              //2
            })
            .catchError(() {})
            .then((val) {});
        _removeIndicator();
        if (_timedOut2 == false) {
          Navigator.pop(context);
        }
      } else {
        _removeIndicator();
        _showToast(
            Colors.red, 'There seems to be a problem with the internet.');
      }
    } else if (_image == null) {
      setState(() {
        _hasNotChosen = true;
      });
    }
  }

  Future<dynamic> _pickSaveImage() async {
    var uuid = Uuid();
    StorageReference ref =
        FirebaseStorage.instance.ref().child(id).child('${uuid.v4()}.jpg');
    StorageUploadTask uploadTask = ref.putFile(_image);
    Duration time = Duration(seconds: 40);

    final future = await uploadTask.onComplete.timeout(time, onTimeout: () {
      print('TIMEOUT');
      uploadTask.cancel();
      _timedOut = true;
    });
    if (_timedOut) {
      return ' ';
    }
    return future.ref.getDownloadURL();
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

  @override
  void initState() {
    overlayState = Overlay.of(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create new article'),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _createTitleTextField(),
                    _createArticleTextField(),
                    _createRadioButtons(),
                    _createImageButton(),
                    _hasNotChosen == true
                        ? Text(
                            'IMAGE REQUIRED',
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
                    _image == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Image.file(_image)),
                    _submitButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
