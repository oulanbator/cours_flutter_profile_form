import 'dart:io';

import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/components.dart';
import '../../constants.dart';
import '../../model/profil.dart';
import '../../service/service.dart';

class ProfilDetails extends StatefulWidget {
  final Profil profil;

  const ProfilDetails({super.key, required this.profil});

  @override
  ProfilDetailsState createState() => ProfilDetailsState();
}

class ProfilDetailsState extends State<ProfilDetails> {
  late Profil _profil;
  File? image;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _presentationController;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _profil = widget.profil;
    _nomController = TextEditingController(text: _profil.nom);
    _prenomController = TextEditingController(text: _profil.prenom);
    _emailController = TextEditingController(text: _profil.email);
    _presentationController = TextEditingController(text: _profil.presentation);

    _nomController.addListener(_checkForModifications);
    _prenomController.addListener(_checkForModifications);
    _emailController.addListener(_checkForModifications);
    _presentationController.addListener(_checkForModifications);
  }

  void _checkForModifications() {
    final isModified = _nomController.text != _profil.nom ||
        _prenomController.text != _profil.prenom ||
        _emailController.text != _profil.email ||
        _presentationController.text != _profil.presentation;

    if (isModified != _isModified) {
      setState(() {
        _isModified = isModified;
      });
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _presentationController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_isModified) {
      _profil.nom = _nomController.text;
      _profil.prenom = _prenomController.text;
      _profil.email = _emailController.text;
      _profil.presentation = _presentationController.text;

      final bool success = await ProfilService().updateProfil(_profil);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la mise à jour du profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateImage(File newImage) async {
    final imageId =
        await UploadFileService().uploadPicture(newImage, _profil.nom!);
    if (imageId != null) {
      final imageUrl = "${Constants.uriAssets}/$imageId";
      _profil.image = imageUrl;

      final bool success = await ProfilService().updateProfil(_profil);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la mise à jour de l\'image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec du téléchargement de l\'image'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      image = newImage;
    });
  }

  void _deleteProfile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le profil'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce profil ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                final bool success =
                    await ProfilService().deleteProfil(_profil.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profil supprimé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Échec de la suppression du profil'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Détails du Profil"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ImagePickerModal(
                          onChoice: (source) async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: source,
                              maxHeight: 600,
                              maxWidth: 600,
                              imageQuality: 50,
                            );
                            if (pickedFile != null) {
                              _updateImage(File(pickedFile.path));
                            }
                          },
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _profil.image != null && _profil.image!.isNotEmpty
                            ? NetworkImage(_profil.image!)
                            : null,
                    child: _profil.image == null || _profil.image!.isEmpty
                        ? Icon(Icons.add_a_photo)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                  icon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                  icon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _presentationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Présentation',
                  icon: Icon(Icons.text_fields),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _deleteProfile,
                    icon: Icon(Icons.delete),
                    label: Text("Supprimer"),
                  ),
                  if (_isModified)
                    ElevatedButton.icon(
                      onPressed: _updateProfile,
                      icon: Icon(Icons.update),
                      label: Text("Enregistrer"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
