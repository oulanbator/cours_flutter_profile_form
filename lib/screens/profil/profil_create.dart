//import 'dart:async';
//import 'dart:convert';

import 'dart:convert';

import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:cours_flutter_profile_form/model/profil.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //
  //
  //
  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      final profil = Profil(
        nom: _nomController.text,
        prenom: _prenomController.text,
        presentation: _descriptionController.text,
        email: _emailController.text,
      );
      final response = await http.post(
        Uri.parse('https://bdew32324.webturtle.fr/items/profil'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profil.toJson()),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('profil crée'),
        ));
        _nomController.clear();
        _prenomController.clear();
        _descriptionController.clear();
        _emailController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('creation de profil echoué : ${response.statusCode}'),
        ));
      }
    }
  }

  //
  //
  //
  //
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'nom', hintText: 'Entrez votre nom'),
                  controller: _nomController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return "entrez un nom (min. 3 caractères)";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'prenom', hintText: 'prenom'),
                  controller: _prenomController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 2) {
                      return 'entrez un prenom (min. 2 caractères)';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Description', hintText: 'decrivez-vous'),
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 20) {
                      return "min. 20 caractères";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return "entrez un email";
                    } else {
                      return null;
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: _submitForm, child: const Text("valider"))
              ],
            )),
      ),
    );
  }
}
