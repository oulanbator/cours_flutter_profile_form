import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';

class ProfilDetails extends StatelessWidget {
  final Profil profil;

  const ProfilDetails({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${profil.nom} ${profil.prenom}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final bool success = await ProfilService().deleteProfil(profil.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete profil'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (profil.image != null)
              Center(
                child: ClipOval(
                  child: Image.network(profil.image!, fit: BoxFit.cover, width: 200, height: 200),
                ),
              ),
            Text('Nom: ${profil.nom}'),
            Text('Prenom: ${profil.prenom}'),
            Text('Email: ${profil.email}'),
            Text('Presentation: ${profil.presentation ?? 'No presentation available'}'),
          ],
        ),
      ),
    );
  }
}