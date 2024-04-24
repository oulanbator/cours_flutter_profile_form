import 'package:flutter/material.dart';
import '../model/profil.dart';
import '../service/profil_service.dart';
import './profil/profil.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profils"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: ProfilService().fetchProfils(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var profils = snapshot.data!;
            return ListView.builder(
                itemCount: profils.length,
                itemBuilder: (context, index) =>
                    _listElement(context, profils[index]));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilCreate(),
          ),
        ),
        tooltip: 'Nouveau profil',
        child: const Icon(Icons.add),
      ),
    );
  }

  _listElement(BuildContext context, Profil profil) {
    return ListTile(
      title: Text("${profil.nom} ${profil.prenom}"),
      subtitle: Text("${profil.presentation}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilDetails(profil: profil),
          ),
        );
      },
    );
  }
}
