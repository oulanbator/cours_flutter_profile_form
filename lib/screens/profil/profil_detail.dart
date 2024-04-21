import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:flutter/material.dart';

class ProfilDetail extends StatelessWidget {
  final Profil profil;
  const ProfilDetail({super.key, required this.profil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _getImage(profil),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  "${profil.prenom} ${profil.nom}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  profil.presentation,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getImage(Profil profil) {
    if (profil.image != null) {
      return Image.network(profil.image!);
    }
    return Container();
  }
}
