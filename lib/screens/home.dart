import 'dart:async';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _profilsFuture = ProfilService().fetchProfils();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _refreshProfils());
  }

  void _refreshProfils() {
    setState(() {
      _profilsFuture = ProfilService().fetchProfils();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profils",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // Rest of your Scaffold code...

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
        // Set the color of the icon to white
        backgroundColor: Theme.of(context)
            .primaryColor,
        child: const Icon(Icons.add, color: Colors.white), // Set the background color of the button to the primary color of your theme
      ),
    );
  }

Widget _listElement(BuildContext context, Profil profil) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
    child: Column(
      children: [
        ListTile(
          leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
          title: Text(
            "${profil.nom} ${profil.prenom}",
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            profil.email ?? 'No email available',
            style: const TextStyle(fontSize: 16.0),
          ),
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
        ),
        const Divider(color: Colors.grey),
      ],
    ),
  );
}
}