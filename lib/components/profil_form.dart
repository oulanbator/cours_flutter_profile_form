import 'dart:io';
import 'package:flutter/material.dart';
import '../model/profil.dart';

class ProfilForm extends StatefulWidget {
  final Profil profil;
  final File? image;
  final Function(Profil, File?) onSave;

  const ProfilForm({
    super.key,
    required this.profil,
    this.image,
    required this.onSave,
  });

  @override
  ProfilFormState createState() => ProfilFormState();
}

class ProfilFormState extends State<ProfilForm> {
  final _formKey = GlobalKey<FormState>();
  late Profil _profil;
  File? _image;

  @override
  void initState() {
    super.initState();
    _profil = widget.profil;
    _image = widget.image;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(_profil, _image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          TextFormField(
            initialValue: _profil.nom,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom',
                icon: Icon(Icons.person)),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 3) {
                return 'Veuillez entre un nom valide';
              }
              return null;
            },
            onSaved: (value) {
              _profil.nom = value!;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prenom',
                icon: Icon(Icons.person)),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 2) {
                return 'Veuillez entrer un prénom valide';
              }
              return null;
            },
            onSaved: (value) {
              _profil.prenom = value!;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                icon: Icon(Icons.email)),
            validator: (value) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (value == null ||
                  value.isEmpty ||
                  !emailRegex.hasMatch(value)) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
            onSaved: (value) {
              _profil.email = value!;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Presentation',
                icon: Icon(Icons.text_fields)),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 20) {
                return 'La presentation doit contenir à minima 20 caractères';
              }
              return null;
            },
            onSaved: (value) {
              _profil.presentation = value!;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
            label: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
