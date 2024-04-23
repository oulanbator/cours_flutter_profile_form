import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilService {
  Future<List<Profil>> fetchProfils() async {
    final response = await http.get(Uri.parse(Constants.uriProfil));

    // Si l'on a un HTTP 200, on parse la réponse de notre webservice
    if (response.statusCode == 200) {
      return parseProfils(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<Profil> parseProfils(String responseBody) {
    final Map<String, dynamic> body = jsonDecode(responseBody);
    final List<dynamic> data = body['data'];
    // Effectue un mapping de chaque élément 'dynamic' de notre List
    // Map un 'Profil' grâce au constructeur .fromJson
    // Retourne une List<Profil> avec .toList();
    return data.map((element) => Profil.fromJson(element)).toList();
  }

  Future<void> saveProfil(Profil profil) async {
    // Convertissez le profil en une carte JSON

    try {
      // Appelez votre API pour sauvegarder le profil
      final response = await http.post(
        Uri.parse(Constants.uriProfil),
        body: jsonEncode(profil.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Vérifiez si la requête a réussi
      if (response.statusCode == 200) {
        // La création du profil a réussi
        return;
      } else {
        // La création du profil a échoué, lancez une exception avec le message d'erreur
        throw Exception('Failed to create profile: ${response.body}');
      }
    } catch (e) {
      // En cas d'erreur lors de la connexion au serveur, lancez une exception avec le message d'erreur
      throw Exception('Failed to create profile: $e');
    }
  }
}
