import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';

import '../../components/ image_handler.dart';

class EditProfilForm extends StatefulWidget {
  final void Function() onProfileUpdated;
  final Profil profil;

  EditProfilForm(
      {Key? key, required this.profil, required this.onProfileUpdated})
      : super(key: key);

  @override
  _EditProfilFormState createState() => _EditProfilFormState();
}

class _EditProfilFormState extends State<EditProfilForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _prenomController;
  late TextEditingController _presentationController;
  late TextEditingController _emailController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profil.nom);
    _prenomController = TextEditingController(text: widget.profil.prenom);
    _presentationController =
        TextEditingController(text: widget.profil.presentation);
    _emailController = TextEditingController(text: widget.profil.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
              color: Colors.white), // Change the color of the title to white
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ImageHandler(
              onImagePicked: (image) {
                _image = image;
              },
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prenom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a prenom';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _presentationController,
              decoration: InputDecoration(labelText: 'Presentation'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a presentation';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),

            Container(
              margin: const EdgeInsets.only(top: 15.0),
              // Add a top margin of 10 pixels
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.profil.nom = _nameController.text;
                    widget.profil.prenom = _prenomController.text;
                    widget.profil.presentation = _presentationController.text;
                    widget.profil.email = _emailController.text;
                    if (_image != null) {
                      widget.profil.image =
                          _image!.path; // Update the image path
                    }
                    final bool success =
                        await ProfilService().updateProfil(widget.profil);
                    if (success) {
                      // Update was successful, navigate back to the profile list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                      widget
                          .onProfileUpdated(); // Notify the parent widget that the profile has been updated
                    } else {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update profile'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context)
                      .primaryColor),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: Colors
                          .white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
