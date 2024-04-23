import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';

class ProfilDetailsPage extends StatelessWidget {
  final Profil profil;

  const ProfilDetailsPage({Key? key, required this.profil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (profil.image != null)
              Image.network(profil.image!, height: 200),
            Text('Nom: ${profil.nom}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Prénom: ${profil.prenom}', style: TextStyle(fontSize: 20)),
            Text('Email: ${profil.email}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Présentation: ${profil.presentation}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
