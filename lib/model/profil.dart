class Profil {
  final String nom;
  final String prenom;
  final String email;
  final String presentation;

  Profil({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.presentation,
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
