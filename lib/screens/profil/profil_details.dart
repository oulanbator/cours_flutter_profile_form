import 'package:cours_flutter_profile_form/screens/profil/profil_edit.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';

class ProfilDetails extends StatefulWidget {
  final Profil profil;
  final VoidCallback onProfileUpdated; // Define the onProfileUpdated method

  const ProfilDetails({Key? key, required this.profil, required this.onProfileUpdated}) : super(key: key);

  @override
  _ProfilDetailsState createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profil.nom} ${widget.profil.prenom}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilForm(profil: widget.profil, onProfileUpdated: () {
                    // This will cause the Home widget to rebuild and display the updated profile
                    setState(() {});
                  },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final bool success = await ProfilService().deleteProfil(widget.profil.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
                print('onProfileUpdated callback is being called'); // Add this print statement
                widget.onProfileUpdated(); // Call the onProfileUpdated method
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete profil'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.profil.image != null)
              Center(
                child: ClipOval(
                  child: Image.network(widget.profil.image!, fit: BoxFit.cover, width: 200, height: 200),
                ),
              ),
            Text('Nom: ${widget.profil.nom}'),
            Text('Prenom: ${widget.profil.prenom}'),
            Text('Email: ${widget.profil.email}'),
            Text('Presentation: ${widget.profil.presentation ?? 'No presentation available'}'),
          ],
        ),
      ),
    );
  }
}