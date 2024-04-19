import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_create.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_details.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Profil>> _profilsFuture;

  @override
  void initState() {
    super.initState();
    _profilsFuture = ProfilService().fetchProfils();
  }

  void _refreshProfils() {
    setState(() {
      _profilsFuture = ProfilService().fetchProfils();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profils"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: _profilsFuture,
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
            builder: (context) => ProfilCreate(
              onProfileUpdated: _refreshProfils,
            ),
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
      subtitle: Text(profil.email ?? 'No email available'),
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilDetails(
              profil: profil,
              onProfileUpdated: _refreshProfils,
            ),
          ),
        );
        if (updated != null && updated) {
          _refreshProfils();
        }
      },
    );
  }
}
