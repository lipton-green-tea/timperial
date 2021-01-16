import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timperial/backend.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:timperial/config.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UploadProfilePicture extends StatefulWidget {
  UploadProfilePicture({this.reloadProfilePages, this.fromCamera = false});

  final BaseBackend backend = new Backend();
  final VoidCallback reloadProfilePages;
  final bool fromCamera;

  @override
  _UploadProfilePictureState createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {

  File selectedImage;
  File croppedImage;
  bool imageSelectionOpenedOnce = false;
  bool openedCropOnce = false;

  Future cropImage() async {
    File newCroppedImage = await ImageCropper.cropImage(
        sourcePath: selectedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 0.9, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Constants.SECONDARY_COLOR,
            toolbarWidgetColor: Constants.OUTLINE_COLOR,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          rectX: 0,
          rectY: 0,
          rectWidth: 90,
          rectHeight: 100,
          aspectRatioLockEnabled: true,
        )
    );

    setState(() {
      croppedImage = newCroppedImage;
    });
  }

  Future<File> resizeImage(File imageFile) {
    return FlutterNativeImage.compressImage(
      imageFile.path,
      quality: 90,
      targetHeight: 440,
      targetWidth: 396
    );
  }

//  Future<File> resizeImage(File imageFile) async {
//    String targetPath = imageFile.path;
//    var resizedImageBytes = await FlutterImageCompress.compressWithFile(
//      imageFile.absolute.path,
//      minWidth: 400,
//      minHeight: 400,
//      quality: 90,
//    );
//    Future<File> resizedImageFuture = File(targetPath).writeAsBytes(resizedImageBytes);
//    return resizedImageFuture;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.BACKGROUND_COLOR,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 22.5,
            color: Constants.INACTIVE_COLOR_DARK,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Upload Profile Picture',
          style: Constants.TEXT_STYLE_HEADER_DARK,
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if(selectedImage == null) {
      if(!imageSelectionOpenedOnce) {
        setState(() {
          imageSelectionOpenedOnce = true;
        });
        if(widget.fromCamera) {
          getImageFromCamera();
        } else {
          getImageFromGallery();
        }
      }
      return Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 5,),
            RaisedButton(
              child: Text('upload image from gallery'),
              onPressed: getImageFromGallery, // TODO: link to upload from gallery function
            ),
            Spacer(flex: 1,),
            RaisedButton(
              child: Text('upload image from camera'),
              onPressed: getImageFromCamera,
            ),
            Spacer(flex: 5,)
          ],
        ),
      );
    } else if(croppedImage == null) {
      if(!openedCropOnce) {
        setState(() {
          openedCropOnce = true;
        });
        cropImage();
      }
      return Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.file(
                  selectedImage,
                  fit: BoxFit.scaleDown,
                ),
              ),
              RaisedButton(
                child: Text('crop image'),
                onPressed: cropImage,
              )
            ],
          )
      );
    } else {
      return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(flex: 1, child: Text(""),),
                ClipRRect(
                  child: Image.file(croppedImage),
                  borderRadius: BorderRadius.circular(20),
                ),
                Expanded(flex: 2, child: Text(""),),
                FlatButton(
                  child: Text(
                      'Done',
                      style: Constants.FLAT_BUTTON_STYLE
                  ),
                  onPressed: () {
                    resizeImage(croppedImage).then((resizedImage) {
                      widget.backend.addProfilePage(resizedImage, widget.reloadProfilePages);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
          )
      );
    }
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = image;
    });
  }
}
