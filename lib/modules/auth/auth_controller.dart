import 'package:flutter/material.dart';
import 'package:snest/api/api.dart';
import 'package:snest/models/models.dart';
import 'package:snest/modules/modules.dart';
import 'package:snest/routes/app_pages.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController extends GetxController {
  final ApiRepository apiRepository;
  final SplashController splashController;
  AuthController({
    required this.apiRepository,
    required this.splashController,
  });

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  bool registerTermsChecked = false;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void register(BuildContext context) async {
    AppFocus.unfocus(context);
    if (registerFormKey.currentState!.validate()) {
      if (!registerTermsChecked) {
        CommonWidget.toast('Please check the terms first.');
        return;
      }
      final res = await apiRepository.register(
        RegisterRequest(
          email: registerEmailController.text,
          password: registerPasswordController.text,
        ),
      );
      final prefs = Get.find<SharedPreferences>();
      if (res!.token.isNotEmpty) {
        prefs.setString(StorageConstants.token, res.token);
        print('Go to Home screen>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      }
    }
  }

  void login(BuildContext context) async {
    AppFocus.unfocus(context);
    if (loginFormKey.currentState!.validate()) {
      final res = await apiRepository.login(
        LoginRequest(
          email: loginEmailController.text,
          password: loginPasswordController.text,
        ),
      );
      final prefs = Get.find<SharedPreferences>();
      if (res!.token.isNotEmpty) {
        prefs.setString(StorageConstants.token, res.token);
        await splashController.getUserInfo();
        Get.toNamed(Routes.HOME);
      }
    }
  }

  Future<void> loginFacebook(BuildContext context) async {
    AppFocus.unfocus(context);
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final String accessToken = result.accessToken!.token;
        final res = await apiRepository.login(
          LoginRequest(
            type: '2',
            token: accessToken,
          ),
        );
        final prefs = Get.find<SharedPreferences>();
        if (res!.token.isNotEmpty) {
          prefs.setString(StorageConstants.token, res.token);
          Get.toNamed(Routes.HOME);
        }
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
  }
}
