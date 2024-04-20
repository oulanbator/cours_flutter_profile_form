import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/profil.dart';
import '../../service/profil_service.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({Key? key}) : super(key: key);

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _presentationController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildImagePicker(),
                    TextFormField(
                      controller: _nomController,
                      decoration: InputDecoration(labelText: 'Nom'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Le nom doit contenir au moins 3 caractères';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _prenomController,
                      decoration: InputDecoration(labelText: 'Prénom'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 2) {
                          return 'Le prénom doit contenir au moins 2 caractères';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Veuillez saisir une adresse email valide';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _presentationController,
                      decoration: InputDecoration(labelText: 'Présentation'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 20) {
                          return 'La présentation doit contenir au moins 20 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: Text('Valider'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: <Widget>[
        _image != null ? Image.file(_image!) : Container(),
        _image == null
            ? IconButton(
          onPressed: _getImage,
          icon: Icon(Icons.add_a_photo),
          tooltip: 'Sélectionner une image',
        )
            : Container(),
      ],
    );
  }

  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Profil profil = Profil(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        presentation: _presentationController.text,
        image: _image,
      );

      ProfilService().createProfil(profil).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil créé avec succès'),
            ),
          );

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la création du profil'),
            ),
          );
        }
      });
    }
  }
}
