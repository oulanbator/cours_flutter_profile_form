import 'package:flutter/material.dart';

import '../../model/profil.dart';

class ProfilDetailsPage extends StatelessWidget {
  final Profil profil;

  const ProfilDetailsPage({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(profil.nom),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (profil.image != null)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profil.image!),
                        fit: BoxFit
                            .cover, // Pour maintenir l'aspect ratio de l'image
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text("Nom : ${profil.nom}"),
                Text("Prénom : ${profil.prenom}"),
                Text("Email : ${profil.email}"),
                Text("Présentation : ${profil.presentation}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Retour'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
