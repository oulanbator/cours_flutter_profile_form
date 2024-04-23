import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/upload_file_service.dart';

class ImageHandler extends StatefulWidget {
  final File? initialImage;
  final void Function(String?) onImageUpdated;

  const ImageHandler({
    super.key,
    this.initialImage,
    required this.onImageUpdated,
  });

  @override
  ImageHandlerState createState() => ImageHandlerState();
}

class ImageHandlerState extends State<ImageHandler> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    widget.onImageUpdated(null);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 600,
      maxWidth: 600,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final imageId = await UploadFileService().uploadPicture(imageFile, 'img');
      if (imageId != null) {
        setState(() {
          _image = imageFile;
        });
        widget.onImageUpdated(imageId);
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galerie'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Caméra'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_image != null)
          CircleAvatar(
            radius: 60,
            backgroundImage: FileImage(_image!),
          )
        else
          CircleAvatar(
            radius: 60,
            child: IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: _showImagePickerModal,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (_image != null) ...[
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: _showImagePickerModal,
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: _removeImage,
              ),
            ]
          ],
        ),
      ],
    );
  }
}
