import 'dart:io';

import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:flutter/material.dart';

import '../../components/ image_handler.dart';
import '../../constants.dart';
import '../../model/profil.dart';
import '../../service/file_transfer_service.dart';

class ProfilCreate extends StatefulWidget {
  final void Function() onProfileUpdated;
  const ProfilCreate({super.key, required this.onProfileUpdated});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();
  final _profil = Profil(nom: '', prenom: '', presentation: '', email: '');
  bool _isSubmitting = false;
  File? _image;

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Nom: ${_profil.nom}, Prenom: ${_profil.prenom}, Presentation: ${_profil.presentation}, Email: ${_profil.email}');

      // If an image is selected, upload it to the server
      if (_image != null) {
        final imageId = await FileTransferService().uploadPicture(_image!, _profil.nom!);
        if (imageId != null) {
          // If the image upload is successful, construct the image URL and add it to the profil data
          _profil.image = "${Constants.uriAssets}/$imageId";
        }
      }

      final bool success = await ProfilService().createProfil(_profil);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil created successfully'),
            backgroundColor: Colors.green, // Set color to green
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        widget.onProfileUpdated(); // Notify the parent widget that the profile has been updated
       // Notify the parent widget that the profile has been updated
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create profil'),
            backgroundColor: Colors.red, // Set color to red
          ),
        );
      }
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nouveau Profil",
          style: TextStyle(color: Colors.white), // Change the color of the title to white
        ),
        backgroundColor: Theme.of(context).primaryColor, // Set the background color of the AppBar
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Add horizontal padding
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
              ImageHandler(
                onImagePicked: (image) {
                  setState(() {
                    _image = image;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom',icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profil.nom = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prenom',icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return 'Please enter a valid prenom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profil.prenom = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email',icon: Icon(Icons.email)),
                validator: (value) {
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profil.email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Presentation',icon: Icon(Icons.text_fields)),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 20) {
                    return 'Please enter a valid presentation';
                  }
                  return null;
                },
                onSaved: (value) {
                  _profil.presentation = value!;
                },
              ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  // Add a top margin of 10 pixels
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
          ),
        ),
      ),
    ),
    );
  }
}