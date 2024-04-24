import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';

class DetailsPage extends StatelessWidget {
  final Profil profil;

  const DetailsPage({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Profil - ${profil.nom}"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrage vertical
            crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  profil.image ?? '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text("Nom : ${profil.nom}"),
              Text("Prénom : ${profil.prenom}"),
              Text("Email : ${profil.email}"),
              Text("Présentation : ${profil.presentation}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retour"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
