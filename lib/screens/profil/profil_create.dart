import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Import for using File
import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/service/fileTransferService.dart';




class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _prenom = '';
  String _email = '';
  String _presentation = '';
  File? _imageFile;  // File variable to hold the image
  final ImagePicker _picker = ImagePicker();

Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 1000,
    maxWidth: 1000,
    imageQuality: 50,
  );

  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}


  Widget _buildImagePicker() {
    return _imageFile == null
        ? IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _pickImage,
          )
        : Image.file(_imageFile!);
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    String? imageId;
    if (_imageFile != null) {
      imageId = await FileTransferService().uploadPicture(_imageFile!, _nom);
    }

    if (imageId != null) {
      String imageUrl = "${Constants.uriAssets}/$imageId";
      Profil newProfil = Profil(
        nom: _nom,
        prenom: _prenom,
        presentation: _presentation,
        email: _email,
        image: imageUrl,
      );

      bool success = await ProfilService().createProfil(newProfil);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil créé avec succès!')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la création du profil')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de lupload de limage')));
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildImagePicker(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Entrez au moins 3 caractères';
                  }
                  return null;
                },
                onSaved: (value) => _nom = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.length < 2) {
                    return 'Entrez au moins 2 caractères';
                  }
                  return null;
                },
                onSaved: (value) => _prenom = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Présentation'),
                validator: (value) {
                  if (value == null || value.length < 20) {
                    return 'Entrez au moins 20 caractères';
                  }
                  return null;
                },
                onSaved: (value) => _presentation = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
