import 'package:flutter/material.dart';
import '../../model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/service/file_transfer_service.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cours_flutter_profile_form/constants.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();
  String? nom;
  String? prenom;
  String? email;
  String? presentation;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imageUrl;
      if (_image != null) {
        String? imageId =
            await FileTransferService().uploadPicture(_image!, "profile_image");
        if (imageId != null) {
          imageUrl = "${Constants.uriAssets}/$imageId";
        }
      }

      Profil newProfil = Profil(
        nom: nom!,
        prenom: prenom!,
        presentation: presentation!,
        email: email!,
        image: imageUrl,
      );

      bool result = await ProfilService().createProfil(newProfil);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profil créé avec succès!"),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de la création du profil."),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              if (_image != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: _pickImage,
                tooltip: 'Pick Image',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Entrez au moins 3 caractères';
                  }
                  return null;
                },
                onSaved: (value) => nom = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.length < 2) {
                    return 'Entrez au moins 2 caractères';
                  }
                  return null;
                },
                onSaved: (value) => prenom = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Présentation'),
                validator: (value) {
                  if (value == null || value.length < 20) {
                    return 'Entrez au moins 20 caractères';
                  }
                  return null;
                },
                onSaved: (value) => presentation = value,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Créer Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
