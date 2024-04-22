class Profil {
  final String nom;
  final String prenom;
  final String presentation;
  final String email;

  String? image;

  // Pas d'id avant le passage en BDD
  int? id;

  Profil(
      {required this.nom,
      required this.prenom,
      required this.presentation,
      required this.email,
      this.image,
      this.id});

  factory Profil.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'nom': String nom,
        'prenom': String prenom,
        'presentation': String presentation,
        'email': String email,
        'image': String? image,
        'id': int? id
      } =>
        Profil(
          nom: nom,
          prenom: prenom,
          presentation: presentation,
          email: email,
          image: image,
          id: id,
        ),
      _ => throw const FormatException('Failed to load profile.'),
    };
  }

  Map<String, dynamic> toJson() => {
        "nom": nom,
        "prenom": prenom,
        "presentation": presentation,
        "email": email,
        "image": image
      };
}
