class Profil {
  final String nom;
  final String prenom;
  final String presentation;
  final String email;
  String? image;
  int? id;

  Profil(
      {required this.nom,
      required this.prenom,
      required this.presentation,
      required this.email});

  Profil.fromJson(Map<String, dynamic> json)
      : nom = json["nom"] as String,
        prenom = json["prenom"] as String,
        presentation = json["presentation"] as String,
        email = json["email"] as String,
        image = json["image"] != null ? json["image"] as String : null,
        id = json["id"] != null ? json["id"] as int : null;

  Map<String, dynamic> toJson() => {
        "nom": nom,
        "prenom": prenom,
        "email": email,
        "presentation": presentation
      };
}
