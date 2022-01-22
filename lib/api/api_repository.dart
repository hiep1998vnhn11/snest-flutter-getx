import 'dart:async';

import 'package:snest/models/models.dart';
import 'package:snest/models/response/users_response.dart';
import 'package:snest/models/response/user_response.dart';

import 'api.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<LoginResponse?> login(LoginRequest data) async {
    final res = await apiProvider.login('auth/login', data);
    return LoginResponse.fromJson(res.body['data']);
  }

  Future<RegisterResponse?> register(RegisterRequest data) async {
    final res = await apiProvider.register('/api/register', data);
    if (res.statusCode == 200) {
      return RegisterResponse.fromJson(res.body);
    }
  }

  Future<CurrentUser?> me() async {
    final res = await apiProvider.me();
    if (res.body['status'] == 0) {
      return CurrentUser.fromJson(res.body['data']);
    }
    return null;
  }

  Future<UsersResponse?> getUsers() async {
    // final res = await apiProvider.getUsers('/api/users?page=1&per_page=12');
    // if (res.statusCode == 200) {
    // return UsersResponse.fromJson(res.body);
    // }
    return null;
  }

  Future<List<Post>> getPosts(PaginationRequest request) async {
    final res = await apiProvider.pagination('user/post', request);
    if (res.body['status'] == 0) {
      return ListPostResponse.fromJson(res.body['data']).posts;
    }
    return [];
  }

  Future<Post?> getPost(String pid) async {
    final res = await apiProvider.get('user/post/$pid');
    if (res.body['status'] == 0) {
      return Post.fromJson(res.body['data']);
    }
    return null;
  }

  Future<User> getUser(String url) async {
    final res = await apiProvider.get('user/$url');
    return User.fromJson(res.body['data']);
  }

  Future<List<Comment>> getComments(
    PaginationRequest request,
    String postUid,
  ) async {
    final res =
        await apiProvider.pagination('user/post/$postUid/comment', request);
    if (res.body['status'] == 0) {
      return ListCommentResponse.fromJson(res.body['data']).comments;
    }
    return [];
  }

  Future<Post?> createPost(CreatePostRequest request) async {
    final res = await apiProvider.createPost(request);
    if (res.body['status'] == 0) {
      return Post.fromJson(res.body['data']);
    }
    return null;
  }
}
