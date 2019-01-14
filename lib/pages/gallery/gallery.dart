import 'package:flutter/material.dart';
import 'package:project_e/model/gallery_model.dart';
import 'package:project_e/widgets/gallery/gallery_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Gallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  List<GalleryModel> images = [];
  Widget _buildText() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10, bottom: 10, top: 20),
      child: Text(
        'GALLERY',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('gallery')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text('NO IMAGES YET'),
            );
          }
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(10),
            primary: false,
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final currentData = snapshot.data.documents[index];
              final GalleryModel currentImage = GalleryModel(
                  imageURL: currentData['imageURL'],
                  title: currentData['title']);
              images.add(currentImage);
              return GalleryObject(img: currentImage);
            },
            staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return CupertinoActivityIndicator();
        }

        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Text('NO BLOGS'),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        _buildText(),
        Expanded(
          child: _buildGallery(),
        )
      ],
    ));
  }
}
