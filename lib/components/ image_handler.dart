import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_modal.dart';

class ImageHandler extends StatefulWidget {
  final void Function(File) onImagePicked;
  ImageHandler({required this.onImagePicked});

  @override
  _ImageHandlerState createState() => _ImageHandlerState();
}

class _ImageHandlerState extends State<ImageHandler> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _imageContainer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _showImagePickerModal(context),
            ),
            if (_image != null) // Only show the remove button if an image is selected
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: _removeImage,
              ),
          ],
        ),
      ],
    );
  }

  Widget _imageContainer() {
    if (_image != null) {
      return Container(
        width: 200.0,
        height: 200.0,
        child: ClipOval(
          child: Image.file(_image!, fit: BoxFit.cover),
        ),
      );
    }

    return Container();
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerModal(
          onChoice: (source) => _pickImage(source),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    await ImagePicker()
        .pickImage(
          source: source,
          maxHeight: 1000,
          maxWidth: 1000,
          imageQuality: 100,
        )
        .then((XFile? image) {
          if (image != null) {
            _setImage(File(image.path));
          }
        });
  }

  void _setImage(File image) {
    setState(() {
      _image = image;
    });
    widget.onImagePicked(image);
  }
}