import 'dart:io' as io;

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
        title: Text(
          '${widget.profil.nom} ${widget.profil.prenom}',
          style: const TextStyle(color: Colors.white), // Change the color of the title to white
        ),
        backgroundColor: Theme.of(context).primaryColor,

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
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
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool? confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this profile?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                final bool success =
                    await ProfilService().deleteProfil(widget.profil.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                  widget.onProfileUpdated();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete profil'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.profil.image != null)
                Center(
                  child: widget.profil.image != null
                      ? (widget.profil.image!.startsWith('http')
                          ? ClipOval(
                              child: Image.network(
                                widget.profil.image!,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                      'No available image for this user');
                                },
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                                io.File(widget.profil.image!),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            ))
                      : const Text('No available image for this user'),
                ),
              const SizedBox(height: 16.0),
                const Text('Nom:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.profil.nom}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 16.0),
                const Text('Prenom:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.profil.prenom}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 16.0),
                const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.profil.email}', style: const TextStyle(fontSize: 18.0)),
                const SizedBox(height: 16.0),
                const Text('Presentation:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.profil.presentation ?? 'No presentation available', style: const TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        ),
    );
  }
}