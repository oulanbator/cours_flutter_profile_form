import 'dart:io';

class Profil {
  final String nom;
  final String prenom;
  final String email;
  final String presentation;
  final File? image;

  Profil({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.presentation,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'presentation': presentation,
    };
  }

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      presentation: json['presentation'],
    );
  }
}
