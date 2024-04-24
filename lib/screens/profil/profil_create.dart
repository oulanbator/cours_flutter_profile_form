import 'dart:io';

import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../model/profil.dart';
import '../../service/service.dart';
import '../../constants.dart';
import '/screens/home.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  Profil _profil = Profil(nom: '', prenom: '', presentation: '', email: '');
  File? _image;

  void _saveProfil(Profil profil, File? image) async {
    final bool success = await ProfilService().createProfil(profil);
    if (!mounted) {
      return;
    }

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil crée / édité avec succés'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création / édition du profil'),
            backgroundColor: Colors.red,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ImageHandler(
                initialImage: _image,
                onImageUpdated: (String? imageId) {
                  setState(() {
                    _profil.image = "${Constants.uriAssets}/$imageId";
                  });
                },
              ),
              ProfilForm(
                profil: _profil,
                image: _image,
                onSave: _saveProfil,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
