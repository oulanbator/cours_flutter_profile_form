import 'package:flutter/material.dart';
import '../../model/profil.dart';

class ProfilDetails extends StatelessWidget {
  final Profil profil;

  const ProfilDetails({Key? key, required this.profil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (profil.image != null) ...[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profil.image!),
                    ),
                    SizedBox(height: 20),
                  ],
                  Text(
                    'Nom: ${profil.nom}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Prénom: ${profil.prenom}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email: ${profil.email}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Présentation: ${profil.presentation}',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
