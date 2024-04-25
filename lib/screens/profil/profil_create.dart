import 'dart:io';

import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/screens/components/image_picker_modal.dart';
import 'package:cours_flutter_profile_form/service/file_transfert_service.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();

  String _nom = "";
  String _prenom = "";
  String _email = "";
  String _presentation = "";
  File? _picture;
  ProfilService _service = ProfilService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              _pictureContainer(),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _showImagePickerModal(context),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                  hintText: 'Entrez votre nom...',
                ),
                onSaved: (value) {
                  _nom = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  } else if (value.length < 3) {
                    return "Minimum 3 caractères";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                  hintText: 'Entrez votre prénom...',
                ),
                onSaved: (value) {
                  _prenom = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  } else if (value.length < 2) {
                    return "Minimum 2 caractères";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Entrez votre adresse email...',
                ),
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                      .hasMatch(value)) {
                    return "Doit être une email valide";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Présentation',
                ),
                onSaved: (value) {
                  _presentation = value!;
                  print("Presentation: {$_presentation}");
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  } else if (value.length < 20) {
                    return "Minimum 20 caractères";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Text("S'inscrire"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _pictureContainer() {
    if (_picture != null) {
      return Image.file(_picture!);
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
    if (source.name != "camera") {
      await ImagePicker()
          .pickImage(
            source: source,
            maxHeight: 1000,
            maxWidth: 1000,
            imageQuality: 50,
          )
          .then((XFile? image) => image != null ? _setImage(image) : null);
    }
  }

  void _setImage(XFile image) {
    setState(() {
      _picture = File(image.path);
    });
  }

  void _submit(BuildContext context) async {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {

      Profil? profil;
      String? pictureId;

      if (_picture != null) {
        pictureId = await FileTransferService().uploadPicture(
          _picture!,
          "${_nom}_${_prenom}",
        );
      }

      if (pictureId == null) {
        profil = Profil(
          nom: _nom,
          prenom: _prenom,
          presentation: _presentation,
          email: _email,
        );
      } else {
        profil = Profil(
          nom: _nom,
          prenom: _prenom,
          presentation: _presentation,
          email: _email,
          image: "${Constants.uriAssets}/${pictureId}",
        );
      }

      bool success = await _service.createProfile(profil);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profil ajouté'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Une erreur est survenue'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
