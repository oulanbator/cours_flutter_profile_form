import 'dart:io';

import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:cours_flutter_profile_form/screens/profil/image_picker_modal.dart';
import 'package:cours_flutter_profile_form/service/file-transfer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _presentationController = TextEditingController();
  final FileTransferService _fileTransferService = FileTransferService();
  File? _picture;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _presentationController.dispose();
    super.dispose();
  }

  Future<bool> _createProfil(Profil profil) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await http.post(
      Uri.parse(Constants.uriProfil),
      headers: headers,
      body: jsonEncode(profil.toJson()),
    );

    if (response.statusCode == 200) {
      return true; // Succès
    } else {
      return false; // Échec
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

var file = await _fileTransferService.uploadPicture(_picture!, "profil");
    

      Profil nouveauProfil = Profil(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        presentation: _presentationController.text,
        image: "${Constants.uriAssets}/$file",
      );

      bool success = await _createProfil(nouveauProfil);

      if (success) {
        // Afficher une notification de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil créé avec succès!'),
            backgroundColor: Colors.green,
          ),
        );

        // Naviguer vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // Afficher une notification d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création du profil.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Renvoie une image si _picture est != null
  Widget _pictureContainer() {
    if (_picture != null) {
      return Image.file(_picture!, width: 200,height: 200);
    }

    return Container();
  }

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

  Future<void> _pickImage(ImageSource source) async {
    await ImagePicker()
        .pickImage(
          source: source,
          maxHeight: 1000,
          maxWidth: 1000,
          imageQuality: 50, // Ici
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pictureContainer(),
              // Et un bouton pour afficher la modale de l'image picker
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _showImagePickerModal(context),
              ),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Le nom doit contenir au moins 3 caractères';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return 'Le prénom doit contenir au moins 2 caractères';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return 'Veuillez saisir une adresse email valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _presentationController,
                decoration: const InputDecoration(labelText: 'Présentation'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 20) {
                    return 'La présentation doit contenir au moins 20 caractères';
                  }
                  return null;
                },
                maxLines: null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
