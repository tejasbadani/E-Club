import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_e/shared/ensure_visible.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_e/shared/custom_loading.dart';

class AddImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddImageState();
  }
}

class _AddImageState extends State<AddImage> {
  File _image;
  bool _hasNotChosen = false;
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();

  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool _isLoading = false;
  bool _timedOut = false;
  bool _timedOut2 = false;
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

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
    );
    setState(() {
      _image = croppedFile;
      _hasNotChosen = false;
    });
  }

  Future<dynamic> _pickSaveImage() async {
    var uuid = Uuid();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('gallery')
        .child('${uuid.v4()}.jpg');
    StorageUploadTask uploadTask = ref.putFile(_image);
    Duration time = Duration(seconds: 40);

    final future = await uploadTask.onComplete.timeout(time, onTimeout: () {
      print('TIMEOUT');
      uploadTask.cancel();
      _timedOut = true;
    });
    if (_timedOut) {
      _timedOut = false;
      return ' ';
    }
    return future.ref.getDownloadURL();
    //return (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    _cropImage(image);
  }

  void _submit() async {
    if (_formKey.currentState.validate() && _image != null) {
      _showIndicator();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat(' MM.d KK:mm a ').format(now);
      final String url = await _pickSaveImage();
      if (url != ' ') {
        final data = {
          'date': formattedDate,
          'title': _titleController.text,
          'imageURL': url
        };
        Duration time = Duration(seconds: 30);
        await Firestore.instance
            .collection('gallery')
            .document()
            .setData(data)
            .timeout(time, onTimeout: () {
          _timedOut2 = true;
        });
        if (_timedOut2) {
          _timedOut2 = false;
          _removeIndicator();
          _showToast(
              Colors.red, 'There seems to be a problem with your connection');
        } else {
          setState(() {
            _titleController.text = '';
            _image = null;
          });
          _showToast(Colors.green, 'UPLOADED IMAGE');
          _removeIndicator();
        }
      }
    } else if (_image == null) {
      setState(() {
        _hasNotChosen = true;
      });
    }
  }

  Widget _submitButton() {
    return Container(
      width: 150,
      height: 40,
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
          'ADD PHOTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
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
          maxLength: 100,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: 'ENTER TITLE',
          ),
          controller: _titleController,
          enabled: !_isLoading,
          validator: (String value) {
            if (value.isEmpty) {
              return 'TITLE REQUIRED';
            }
          },
        ),
      ),
    );
  }

  Widget _createImageIcon() {
    return Container(
      margin: EdgeInsets.all(10),
      child: IconButton(
        icon: Icon(Icons.photo_camera),
        onPressed: () {
          if (_isLoading == false) {
            getImage();
          }
        },
        color: Theme.of(context).primaryColor,
        iconSize: 35,
      ),
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
          appBar: AppBar(
            title: Text('UPLOAD IMAGES',style: TextStyle(fontSize: 15),),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _createTitleTextField(),
                  _createImageIcon(),
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
    );
  }
}
