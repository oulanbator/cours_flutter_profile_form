import 'dart:convert';
import 'dart:io';
import 'package:cours_flutter_profile_form/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileTransferService {
  /// Renvoie l'id de l'image téléversée, ou null en cas d'échec
  Future<String?> uploadPicture(File picture, String title) async {
    final fileBytes = await picture.readAsBytes();
    // C'est une bonne pratique d'avoir un timestamp dans le nom d'une image
    final filename = "${title}_${DateTime.now().millisecondsSinceEpoch}.jpg";

    // Préparation de la requête à envoyer
    final request =
    http.MultipartRequest('POST', Uri.parse(Constants.uriFileTransfert))
      ..fields['title'] = title
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
        contentType: MediaType.parse("image/jpeg"),
      ));

    // Envoi de la requête
    final response = await request.send();

    // Renvoie l'id de l'image si la requête réussit, sinon null
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      Map<String, dynamic> decodedBody = jsonDecode(responseBody);
      Map<String, dynamic> data = decodedBody['data'];
      return data['id'];
    } else {
      print("Bad response. Status code : ${response.statusCode}");
      return null;
    }
  }
}