import 'package:cours_flutter_profile_form/app.dart';
import 'package:cours_flutter_profile_form/service/profil_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProfilService(),
      child: const App(),
    ),
  );
}
