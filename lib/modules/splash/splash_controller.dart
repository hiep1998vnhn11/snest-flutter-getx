import 'package:snest/routes/routes.dart';
import 'package:snest/api/api.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snest/models/response/user_response.dart';

class SplashController extends GetxController {
  final ApiRepository apiRepository = Get.find();
  var currentUser = Rxn<CurrentUser>();
  Future<void> getUserInfo() async {
    try {
      final user = await apiRepository.me();
      currentUser.value = user;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    var storage = Get.find<SharedPreferences>();
    try {
      if (storage.getString(StorageConstants.token) != null) {
        if (currentUser.value == null) await getUserInfo();
        Get.toNamed(Routes.HOME);
      } else {
        Get.toNamed(Routes.AUTH);
      }
    } catch (e) {
      Get.toNamed(Routes.AUTH);
    }
  }
}
