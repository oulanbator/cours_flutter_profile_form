import 'package:flutter/material.dart';
import '../../model/profil.dart';

class ProfileDetails extends StatelessWidget {
  final Profil profil;

  const ProfileDetails({Key? key, required this.profil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${profil.nom} ${profil.prenom}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (profil.image != null && profil.image!.isNotEmpty)
              SizedBox(
                height: 150, 
                width: 150,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profil.image!),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Erreur lors du chargement de l\'image: $exception');
                  },
                  radius: 70, 
                ),
              ),
            ListTile(
              title: Text('Nom'),
              subtitle: Text(profil.nom),
            ),
            ListTile(
              title: Text('Prénom'),
              subtitle: Text(profil.prenom),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(profil.email),
            ),
            ListTile(
              title: Text('Présentation'),
              subtitle: Text(profil.presentation),
            ),
          ],
        ),
      ),
    );
  }
}
