class Profil {
  final String nom;
  final String prenom;
  final String presentation;
  final String email;
  // L'image n'est pas obligatoire
  String? image;
  // L'id n'est pas connu au moment de la création du profil
  int? id;

  Profil(
      {required this.nom,
      required this.prenom,
      required this.presentation,
      required this.email,
      this.image,
      this.id});

  Profil.fromJson(Map<String, dynamic> json)
      : nom = json["nom"] as String,
        prenom = json["prenom"] as String,
        presentation = json["presentation"] as String,
        email = json["email"] as String,
        image = json["image"] != null ? json["image"] as String : null,
        id = json["id"] != null ? json["id"] as int : null;

  Map<String, dynamic> toJson() {

    Map<String, dynamic> json = {
      "nom": nom,
      "prenom": prenom,
      "presentation": presentation,
      "email": email,
    };

    if (image != null) {
      json["image"] = image;
    }

    return json;
    
  }
}
