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

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
    );
    setState(() {
      _image = croppedFile;
      _hasNotChosen = false;
    });
  }

  @override
  void initState() {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) => CustomLoading());
    super.initState();
  }

  Future<dynamic> _pickSaveImage() async {
    var uuid = Uuid();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('gallery')
        .child('${uuid.v4()}.jpg');
    StorageUploadTask uploadTask = ref.putFile(_image);
    return (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1000, maxWidth: 1000);
    _cropImage(image);
  }

  void _submit() async {
    if (_formKey.currentState.validate() && _image != null) {
      setState(() {
        _isLoading = true;
      });

      overlayState.insert(overlayEntry);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat(' d.MM KK:mm a ').format(now);
      final String url = await _pickSaveImage();
      final data = {
        'date': formattedDate,
        'title': _titleController.text,
        'imageURL': url
      };
      await Firestore.instance.collection('gallery').document().setData(data);

      Fluttertoast.showToast(
          msg: 'UPLOADED IMAGE',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          textColor: Colors.white,
          backgroundColor: Colors.green);
      setState(() {
        _titleController.text = '';
        _image = null;
        _isLoading = false;
      });
      overlayEntry.remove();
    } else if (_image == null) {
      setState(() {
        _hasNotChosen = true;
      });
    }
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
          'ADD PHOTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
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
        iconSize: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
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
    );
  }
}
