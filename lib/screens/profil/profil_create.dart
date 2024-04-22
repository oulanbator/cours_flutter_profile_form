import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

import '../../model/profil.dart';

import '../components/image_picker_modal.dart';

import '../../service/profil_service.dart';
import '../../service/file_transfer_service.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _presentationController = TextEditingController();

  final _profilService = ProfilService();
  final _fileTransferService = FileTransferService();

  File? _picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nouveau Profil"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // Utilisation de la largeur de l'écran
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // -------- Form / TextFormField --------
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _pictureContainer(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _nomController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                                labelText: "Nom",
                              ),
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "Veuillez entrer votre nom";
                                }
                                if (value.length < 3) {
                                  return "Votre nom doit faire plus de 3 caractères";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _prenomController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_rounded),
                                labelText: "Prénom",
                              ),
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "Veuillez entrer votre prénom";
                                }
                                if (value.length < 2) {
                                  return "Votre nom doit faire plus de 2 caractères";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.mail),
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                final RegExp regex =
                                    RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Saisir un email valide';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _presentationController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.description),
                                labelText: "Présentation",
                              ),
                              validator: (value) {
                                if (value == "" || value == null) {
                                  return "Veuillez entrer votre description";
                                }
                                if (value.length < 20) {
                                  return "Votre présentation doit faire plus de 20 caractères";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () => _submitForm(),
                                child: const Text("Enregistrer le profil")),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  /// Renvoie une image si _picture est != null
  Widget _pictureContainer() {
    if (_picture != null) {
      return Column(
        children: [
          Container(
            height: 200, // Définir la hauteur maximale
            width: 200, // Définir la largeur maximale
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

  _submitForm() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _picture != null) {
      _formKey.currentState!.save();
      _fileTransferService
          .uploadPicture(
              _picture!, "${_nomController.text}_${_prenomController.text}")
          .then((value) {
        if (value != null) {
          print("${Constants.uriAssets}/$value");
          Profil profil = Profil(
            nom: _nomController.text,
            prenom: _prenomController.text,
            email: _emailController.text,
            presentation: _presentationController.text,
            image: "${Constants.uriAssets}/$value",
          );
          _createProfil(profil);
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

  _createProfil(Profil profil) {
    _profilService.createProfil(profil).then((value) {
      if (value) {
        Navigator.pop(context, profil);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Création du profil réussie"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la création du profil"),
          ),
        );
      }
    });
  }
}
