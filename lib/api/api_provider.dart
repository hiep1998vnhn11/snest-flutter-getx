import 'package:snest/api/base_provider.dart';
import 'package:snest/models/models.dart';
import 'package:get/get.dart';

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
    return post(path, data.toJson());
  }
}