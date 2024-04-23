import 'dart:io';

import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/screens/components/image_picker_modal.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:cours_flutter_profile_form/service/image_service.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _presentationController = TextEditingController();
  bool _isImageSelected = false;
  File? _picture;
  final _fileService = FileTransferService();
  final _profilService = ProfilService();

  @override
  Widget build(BuildContext context) {
    // var profilService = Provider.of<ProfilService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _pictureContainer(),
          if (!_isImageSelected)
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _showImagePickerModal(context),
            ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Nom"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ est incomplet";
                      }
                      if (value.length < 3) {
                        return "Le champ doit contenir au moins 3 caractères";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Prenom"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ est incomplet";
                      }
                      if (value.length < 2) {
                        return "Le champ doit contenir au moins 2 caractères";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ est incomplet";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _presentationController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Presentation"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le champ est incomplet";
                      }
                      if (value.length < 20) {
                        return "Le champ doit contenir au moins 20 caractères";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  OverflowBar(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submitForm(),
                          // onPressed: () => _submitForm(profilService, context),
                          child: const Text("Submit"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _submitForm(ProfilService profilService, BuildContext context) async {
  void _submitForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        Profil profil;

        if (_picture != null) {
          var file =
              await _fileService.uploadPicture(_picture!, _nameController.text);

          profil = Profil(
            nom: _nameController.text,
            prenom: _firstnameController.text,
            email: _emailController.text,
            presentation: _presentationController.text,
            image: "${Constants.uriAssets}/$file",
          );
        } else {
          profil = Profil(
            nom: _nameController.text,
            prenom: _firstnameController.text,
            email: _emailController.text,
            presentation: _presentationController.text,
          );
        }

        bool success = await _profilService.createProfil(profil);

        if (success) {
          _successMessageAndNavigate();
        }
      }
    }
  }

  void _successMessageAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Complété avec succès !"),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  /// Renvoie une image si _picture est != null
  Widget _pictureContainer() {
    if (_picture != null) {
      _isImageSelected = true;

      return Image.file(
        _picture!,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      _isImageSelected = false;
    }

    return Container();
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
