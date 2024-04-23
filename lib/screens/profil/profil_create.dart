import 'dart:async';
import 'dart:io';

import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/screens/home.dart';
import 'package:cours_flutter_profile_form/service/file_transfert_service.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../components/image_picker_modal.dart';

final _formKey = GlobalKey<FormState>();

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  late File image;

  var _formKey = GlobalKey<FormState>();

  //Controllers des champs texte
  var _nomController = TextEditingController();
  var _prenomController = TextEditingController();
  var _emailController = TextEditingController();
  var _presentationController = TextEditingController();

  File? _picture;
  //Bool pour caché ou pas le bouton pour créer un profil, le temps du chargement.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _pictureContainerFunction(),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _showImagePickerModal(context),
                  ),
                  SizedBox(height: 10),
                  buildPrenomFormField(),
                  SizedBox(height: 10),
                  buildNomFormField(),
                  SizedBox(height: 10),
                  buildDescriptionFormField(),
                  SizedBox(height: 10),
                  buildMailFormField(),
                  SizedBox(height: 10),
                  Visibility(
                    child: ElevatedButton(
                        onPressed: () => _submitForm(),
                        child: Text("Créer le profil")),
                    visible: _visible,
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  _pictureContainerFunction() {
    if (_picture != null) {
      return SizedBox(
        child: Image.file(_picture!),
        height: 200,
      );
    }
    return Container();
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImagePickerModal(
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
          imageQuality: 50,
        )
        // Si l'image a été choisie, appelle la méthode _setImage, sinon ne fait rien
        .then((XFile? image) => image != null ? _setImage(image) : null);
  }

  void _setImage(XFile image) {
    setState(() {
      _picture = File(image.path);
    });
  }

  TextFormField buildMailFormField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.mail),
        hintText: "Entrez votre email",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ doit être renseigné';
        }
        final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!regex.hasMatch(value)) {
          return 'Saisir un email valide';
        }
        return null;
      },
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _presentationController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.description),
        hintText: "Entrez votre description",
      ),
      validator: (value) {
        if (value == "" || value == null) {
          return "Champ obligatoire";
        }
        if (value.length < 21) {
          return "Votre description doit faire plus de 20 caractères";
        }
        return null;
      },
    );
  }

  TextFormField buildNomFormField() {
    return TextFormField(
      controller: _nomController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.person),
        hintText: "Entrez votre nom",
      ),
      validator: (value) {
        if (value == "" || value == null) {
          return "Champ obligatoire";
        }
        if (value.length < 4) {
          return "Votre nom doit faire plus de 3 caractères";
        }
        return null;
      },
    );
  }

  TextFormField buildPrenomFormField() {
    return TextFormField(
      controller: _prenomController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.person),
        hintText: "Entrez votre prénom",
      ),
      validator: (value) {
        if (value == "" || value == null) {
          return "Champ obligatoire";
        }
        if (value.length < 5) {
          return "Votre nom doit faire plus de 5 caractères";
        }
        return null;
      },
    );
  }

  _submitForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        //Permet de cacher le bouton.
        setState(() {
          _visible = !_visible;
        });

        String? idImage;
        if (_picture != null) {
          idImage = await FileTransferService().uploadPicture(_picture!, 'test');
        }

        String res = await ProfilService().createProfil(Profil(
          nom: _nomController.text,
          prenom: _prenomController.text,
          presentation: _presentationController.text,
          email: _emailController.text,
          image: idImage != null ? Constants.uriAssets + idImage : null,
        ));

        //Affichage d'un msg d'echec ou confirmation en fonction de la réponse ok ou nok.
        if (res == 'ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Le profil a bien été créé.'),
            ),
          );
        } else if (res == 'nok') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Une erreur est survenue lors de la création du profil.'),
            ),
          );
        }

        _visible = false;

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Home();
        }));
      }
    }
  }
}
