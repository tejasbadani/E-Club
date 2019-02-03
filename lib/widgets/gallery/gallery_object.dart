import 'package:flutter/material.dart';
import 'package:project_e/model/gallery_model.dart';

class GalleryObject extends StatefulWidget {
  final GalleryModel img;
  GalleryObject({this.img});
  @override
  State<StatefulWidget> createState() {
    return _GalleryObjectState();
  }
}

class _GalleryObjectState extends State<GalleryObject> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7.0,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Opacity(
              opacity: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: FadeInImage(
                  placeholder: Image.asset('assets/network.png').image,
                  image: NetworkImage(widget.img.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 1.0,
            child: Container(
              margin: EdgeInsets.only(left: 5, bottom: 5, top: 5),
              alignment: Alignment.centerLeft,
              //color: Colors.white,
              child: Text(
                ' ${widget.img.title} ',
                maxLines: 3,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
