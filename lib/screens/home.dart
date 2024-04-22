import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_create.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_details.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profils"),
      ),
      body: FutureBuilder(
        future: ProfilService().fetchProfils(),
        builder: (context, AsyncSnapshot<List<Profil>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erreur: ${snapshot.error}"),
            );
          } else {
            final List<Profil> profils = snapshot.data!;
            return ListView.builder(
              itemCount: profils.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilDetails(profil: profils[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            "${profils[index].nom} ${profils[index].prenom}",
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            profils[index].presentation,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
}
