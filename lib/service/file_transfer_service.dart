import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:cours_flutter_profile_form/constants.dart'; 

class FileTransferService {
  Future<String?> uploadPicture(File picture, String title) async {
    try {
      final Uri uri = Uri.parse(Constants.uriFileTransfert);
      final fileBytes = await picture.readAsBytes();
      final filename = "${title}_${DateTime.now().millisecondsSinceEpoch}.jpg";

      var request = http.MultipartRequest('POST', uri)
        ..fields['title'] = title
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: filename,
          contentType: MediaType(
              'image', 'jpeg'), 
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        String imageId = decodedResponse['data']
            ['id'];
        return imageId;
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
