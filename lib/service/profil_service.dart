import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilService {
  Future<List<Profil>> fetchProfils() async {
    final response = await http.get(Uri.parse(Constants.uriProfil));

    if (response.statusCode == 200) {
      print('Fetching updated list of profiles');
      return parseProfils(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<Profil> parseProfils(String responseBody) {
    final Map<String, dynamic> body = jsonDecode(responseBody);
    final List<dynamic> data = body['data'];
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
    print('Profile deleted successfully');
    return true;
  } else {
    print('Error: Failed to delete profil. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}

Future<bool> updateProfil(Profil profil) async {
  if (profil.id == null) {
    print('Error: Profil id is null');
    return false;
  }

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
    print('Error: Failed to update profil. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }
}


}