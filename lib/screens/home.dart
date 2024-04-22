import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_create.dart';
import 'package:cours_flutter_profile_form/screens/profil/profil_details_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final ValueNotifier<int> _refreshNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _refreshNotifier,
      builder: (context, value, child) {
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
                return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
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
            onPressed: () async {
              final newProfil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilCreate(),
                ),
              );
              if (newProfil != null) {
                _refreshNotifier.value++;
              }
            },
            tooltip: 'Nouveau profil',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  _listElement(BuildContext context, Profil profil) {
    return ListTile(
      title: Text("${profil.nom} ${profil.prenom}"),
      subtitle: Text(profil.email),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilDetailsPage(profil: profil),
            ));
      },
    );
  }
}
