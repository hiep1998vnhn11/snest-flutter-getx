import 'package:snest/api/base_provider.dart';
import 'package:snest/models/models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<void> uploadFile({
    required XFile file,
    required int objectId,
    required String objectType,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.uploadUrl),
    );
    final token = (await SharedPreferences.getInstance()).getString('token');
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['object_id'] = objectId.toString();
    request.fields['object_type'] = objectType;
    await request.send();
  }
}
