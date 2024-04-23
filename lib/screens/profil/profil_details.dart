import 'package:flutter/material.dart';

import '../../model/profil.dart';

class ProfilDetails extends StatelessWidget {
  final Profil profil;

  const ProfilDetails({super.key, required this.profil});

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
          width: MediaQuery.of(context).size.width, // Utilisation de la largeur de l'écran
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary, // Border color
                        width: 3.0, // Border width
                      ),
                      image: DecorationImage(
                        image: NetworkImage(profil.image!),
                        fit: BoxFit
                            .cover, // Pour maintenir l'aspect ratio de l'image
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                const Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    "Nom Prénom"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      textAlign: TextAlign.center,
                      "${profil.nom} ${profil.prenom}"),
                ),
                const SizedBox(height: 10),
                const Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    "Email"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      textAlign: TextAlign.center,
                      profil.email),
                ),
                const SizedBox(height: 10),
                const Text(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    "Présentation"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      textAlign: TextAlign.center,
                      profil.presentation),
                ),
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