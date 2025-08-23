import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_social_media/features/storage/domain/storage_repo.dart';

class CloudinaryStorageRepo extends StorageRepo {
  final String cloudName = "dimcsqgzr"; // from Cloudinary dashboard
  final String uploadPreset = "my_preset"; // from Cloudinary

  // mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    final file = File(path);
    return _uploadFile(file, fileName, 'profile_images');
  }

  // web platform
  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) async {
    return _uploadFileBytes(fileBytes, fileName, 'profile_images');
  }

  // helper method for mobile (file)
  Future<String?> _uploadFile(File file, String fileName, String folder) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folder
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final data = json.decode(resBody);

      return data["secure_url"]; // hosted image URL
    } catch (e) {
      return null;
    }
  }

  // helper method for web (bytes)
  Future<String?> _uploadFileBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = folder
        ..files.add(http.MultipartFile.fromBytes("file", fileBytes, filename: fileName));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final data = json.decode(resBody);

      return data["secure_url"];
    } catch (e) {
      return null;
    }
  }
}
