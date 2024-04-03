import 'dart:io';

import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/ image_handler.dart';
import '../../model/profil.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({Key? key}) : super(key: key);

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();
  final _profil = Profil(nom: '', prenom: '', presentation: '', email: '');
  File? _image;

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Nom: ${_profil.nom}, Prenom: ${_profil.prenom}, Presentation: ${_profil.presentation}, Email: ${_profil.email}');
      final bool success = await ProfilService().createProfil(_profil);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil created successfully'),
            backgroundColor: Colors.green, // Set color to green
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create profil'),
            backgroundColor: Colors.red, // Set color to red
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
      ),
      body: SingleChildScrollView(
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
                  if (value == null || value.isEmpty || !value.contains('@')) {
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
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}