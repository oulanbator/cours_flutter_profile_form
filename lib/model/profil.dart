class Profil {
  String? nom;
  String? prenom;
  String? presentation;
  String? email;
  String? image;
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
    final Map<String, dynamic> data = {
      'nom': nom,
      'prenom': prenom,
      'presentation': presentation,
      'email': email,
    };

    if (image != null) {
      data['image'] = image;
    }

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }
}
