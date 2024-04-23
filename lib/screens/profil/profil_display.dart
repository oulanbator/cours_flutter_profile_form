import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:flutter/material.dart';

class ProfilDisplay extends StatelessWidget {
  final Profil profil;

  const ProfilDisplay({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Profil - ${profil.nom} ${profil.prenom}"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (profil.image != null) Image.network(profil.image!),
              if (profil.image == null)
                Text("Nom et Prenom : ${profil.nom} ${profil.prenom}"),
              const SizedBox(height: 12),
              Text("Email : ${profil.email}"),
              const SizedBox(height: 12),
              Text("Presentation : ${profil.presentation}"),
              const SizedBox(height: 12),
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
