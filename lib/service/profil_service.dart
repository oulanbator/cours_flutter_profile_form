import 'package:cours_flutter_profile_form/constants.dart';
import 'package:cours_flutter_profile_form/model/profil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilService {
  Future<List<Profil>> fetchProfils() async {
    final response = await http.get(Uri.parse(Constants.uriProfil));

    if (response.statusCode == 200) {
      return parseProfils(response.body);
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  List<Profil> parseProfils(String responseBody) {
    final Map<String, dynamic> body = jsonDecode(responseBody);
    final List<dynamic> data = body['data'];
    return data.map((element) => Profil.fromJson(element)).toList();
  }

  Future<bool> createProfil(Profil profil) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(
        Uri.parse(Constants.uriProfil),
        headers: headers,
        body: jsonEncode(profil.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to create profil: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Caught error: $e');
      return false;
    }
  }
}
