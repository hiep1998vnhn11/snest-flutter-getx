import 'package:snest/routes/routes.dart';
import 'package:snest/api/api.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snest/models/response/user_response.dart';

class ProfileController extends GetxController {
  final ApiRepository apiRepository = Get.find();

  var user = Rxn();

  @override
  void onReady() async {
    super.onReady();
    var storage = Get.find<SharedPreferences>();
  }
}
