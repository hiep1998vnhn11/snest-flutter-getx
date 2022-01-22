import 'dart:io';

import 'package:snest/api/base_provider.dart';
import 'package:snest/models/models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ApiProvider extends BaseProvider {
  Future<Response> login(String path, LoginRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> register(String path, RegisterRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getUsers(String path) {
    return get(path);
  }

  Future<Response> me() {
    return get('auth/me');
  }

  Future<Response> pagination(String path, PaginationRequest data) {
    return get(path, query: data.toJson());
  }

  Future<Response> createPost(CreatePostRequest request) {
    return post('user/post', request.toJson());
  }

  static Future<int> uploadFile({
    required XFile file,
    int? objectId,
    String? objectType,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.uploadUrl),
    );
    final token = (await SharedPreferences.getInstance()).getString('token');
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    if (objectId != null) request.fields['object_id'] = objectId.toString();
    if (objectType != null) request.fields['object_type'] = objectType;
    final http.StreamedResponse res = await request.send();
    final response = await res.stream.bytesToString();
    final Map<String, dynamic> data = json.decode(response);
    return data['data'];
  }

  static Future<bool> downloadImage(String url) async {
    final splited = url.split('/');
    final fileName = splited.last;
    final documentDirectory = await getApplicationDocumentsDirectory();
    final firstPath = documentDirectory.path + '/images';
    final filePath =
        '$firstPath/${DateTime.now().microsecondsSinceEpoch}_$fileName';
    await Directory(firstPath).create(recursive: true);

    final response = await http.get(Uri.parse(url));
    File file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);
    return true;
  }
}
