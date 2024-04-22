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

  Future<bool> createProfil(Profil profil) async {
    final response = await http.post(
      Uri.parse(Constants.uriProfil),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(profil.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erreur lors de la création du profil');
    }
  }
}
