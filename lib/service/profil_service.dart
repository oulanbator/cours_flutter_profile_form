import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';
import '../model/profil.dart';

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
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await http.post(
      Uri.parse(Constants.uriProfil),
      headers: headers,
      body: jsonEncode(profil.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erreur lors de la création du profil: ${response.body}');
      return false;
    }
  }

  Future<bool> updateProfil(Profil profil) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await http.patch(
      Uri.parse('${Constants.uriProfil}/${profil.id}'),
      headers: headers,
      body: jsonEncode(profil.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erreur lors de la mise à jour du profil: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteProfil(int? id) async {
    if (id == null) {
      print('Error: Profil id is null');
      return false;
    }

    final response = await http.delete(
      Uri.parse('${Constants.uriProfil}/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Erreur lors de la suppression du profil: ${response.body}');
      return false;
    }
  }
}
