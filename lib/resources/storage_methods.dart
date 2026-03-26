import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  static final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static const String _uploadPreset = 'custompre'; // unsigned preset
  static final String _baseUrl = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';


  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    final String uid = _auth.currentUser!.uid;

 
    //   profile pics  →  <childName>/<uid>
    //   posts         →  <childName>/<uid>/<uuid>
    final String publicId = isPost
        ? '$childName/$uid/${const Uuid().v1()}'
        : '$childName/$uid';

    final uri = Uri.parse(_baseUrl);

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['public_id'] = publicId
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        file,
        filename: '$publicId.jpg',
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${response.body}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final String downloadUrl = data['secure_url'] as String;

    return downloadUrl;
  }
}