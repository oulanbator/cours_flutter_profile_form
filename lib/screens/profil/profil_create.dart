import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';

import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../components/image_picker_modal.dart';
import '../../service/file_transfer_service.dart';


import '../home.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({Key? key}) : super(key: key);

  @override
  _ProfilCreateState createState() => _ProfilCreateState();
}


class _ProfilCreateState extends State<ProfilCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _nom;
  late String _prenom;
  late String _email;
  late String _presentation;

  File? _picture;
  final _fileTransferService = FileTransferService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: picContainer(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Veuillez entrer un nom valide (3 caractères minimum)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nom = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return 'Veuillez entrer un prénom valide (2 caractères minimum)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _prenom = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !isValidEmail(value)) {
                      return 'Veuillez entrer une adresse email valide';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Présentation',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 20) {
                      return 'Veuillez entrer une présentation valide (20 caractères minimum)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _presentation = value!;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitForm() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _picture != null) {
      _formKey.currentState!.save();
      _fileTransferService
          .uploadPicture(
          _picture!, "${_nom}_${_prenom}")
          .then((value) {
        if (value != null) {
          print("${Constants.uriAssets}/$value");
          Profil profil = Profil(
            nom: _nom,
            prenom: _prenom,
            email: _email,
            presentation: _presentation,
            image: "${Constants.uriAssets}/$value",
          );
          _saveProfil(profil);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erreur lors de l'envoi de l'image"),
            ),
          );
        }
      });
    }
  }

  void _saveProfil(Profil profil) async {
    try {
      await ProfilService().saveProfil(profil);
      // Appelez votre service pour sauvegarder le profil
      // Retournez à l'écran précédent
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      // Affichez une erreur si la sauvegarde échoue
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la sauvegarde du profil: $e'),
      ));
    }
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Widget picContainer() {
    if (_picture != null) {
      return Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary, // Border color
                width: 3.0, // Border width
              ),
              image: DecorationImage(
                image: FileImage(_picture!),
                fit: BoxFit.cover, // Pour maintenir l'aspect ratio de l'image
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => setState(() => _picture = null),
              child: const Text("Supprimer l'image")),
        ],
      );
    }
    return _imagePickerButton();
  }

  /// Renvoie un bouton pour choisir une image
  Widget _imagePickerButton() {
    return IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () => _showImagePickerModal(context),
    );
  }

  /// Renvoie la modale pour choisir la source de l'image (Galerie / Camera)
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerModal(
          // Lorsque le callback onChoice est appelé, passe la "source" à la méthode _pickImage
          onChoice: (source) => _pickImage(source),
        );
      },
    );
  }

  /// Permet l'affichage de l'imagePicker lui-même en fonction de la source
  Future<void> _pickImage(ImageSource source) async {
    await ImagePicker()
        .pickImage(
      source: source,
      maxHeight: 1000,
      maxWidth: 1000,
      imageQuality: 50,
    )
    // Si l'image a été choisie, appelle la méthode _setImage, sinon ne fait rien
        .then((XFile? image) => image != null ? _setImage(image) : null);
  }

  /// Affecte l'image dans la variable _picture avec setState (pour forcer un nouveau rendu de notre widget)
  void _setImage(XFile image) {
    setState(() {
      _picture = File(image.path);
    });
  }
}
