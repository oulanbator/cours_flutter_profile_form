import 'package:flutter/material.dart';

class ProfilCreate extends StatefulWidget {
  const ProfilCreate({super.key});

  @override
  State<ProfilCreate> createState() => _ProfilCreateState();
}

class _ProfilCreateState extends State<ProfilCreate> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _presentationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Profil"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le champ est incomplet";
                  }
                  if (value.length < 3) {
                    return "Le champ doit contenir au moins 3 caractères";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Prenom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le champ est incomplet";
                  }
                  if (value.length < 2) {
                    return "Le champ doit contenir au moins 2 caractères";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le champ est incomplet";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _presentationController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Presentation"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le champ est incomplet";
                  }
                  if (value.length < 20) {
                    return "Le champ doit contenir au moins 20 caractères";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              OverflowBar(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(),
                      child: const Text("Submit"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        print('hello');
        print('Name: ${_nameController.text}');
        print('FirstName: ${_firstnameController.text}');
        print('Mail: ${_emailController.text}');
        print('Presentation: ${_presentationController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Complété avec succès !"),
          ),
        );
      }
    }
  }

  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
