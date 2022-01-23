import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

FutureOr<Request> requestInterceptor(Request request) async {
  final token = (await SharedPreferences.getInstance()).getString('token');

  // request.headers['X-Requested-With'] = 'XMLHttpRequest';
  request.headers['Authorization'] = 'Bearer $token';
  if (request.method != 'get' && request.headers['silent'] == null)
    EasyLoading.show(status: 'loading...');
  return request;
}
