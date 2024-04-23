import 'package:flutter/material.dart';
import '../../model/profil.dart';

class ProfilDetails extends StatelessWidget {
  final Profil profil;

  const ProfilDetails({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Profil - ${profil.prenom}"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              profil.image != null ? SizedBox(child: Image.network(profil.image.toString()),height: 300,) : SizedBox(),
              Text("Espèce : ${profil.nom}"),
              Text("Origine : ${profil.prenom}"),
              Text("Statut : ${profil.presentation}"),
              Text("Statut : ${profil.email}"),
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