import 'package:flutter/material.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GradientBackground(
          needTopRadius: false,
          needTopSafeArea: false,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CommonWidget.appBar(
            context,
            'Đăng nhập',
            Icons.arrow_back,
            Colors.white,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: _buildForms(context),
          ),
        ),
      ],
    );
  }

  Widget _buildForms(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputField(
              controller: controller.loginEmailController,
              keyboardType: TextInputType.text,
              labelText: 'Email hoặc số điện thoại',
              placeholder: 'Nhập email hoặc số điện thoại',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy nhập email hoặc số điện thoại.';
                }
                return null;
              },
            ),
            CommonWidget.rowHeight(),
            InputField(
              controller: controller.loginPasswordController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Mật khẩu',
              placeholder: 'Mật khẩu của bạn',
              password: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập mật khẩu.';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
            ),
            CommonWidget.rowHeight(height: 80),
            BorderButton(
              text: 'Đăng nhập',
              backgroundColor: Colors.white,
              onPressed: () {
                controller.login(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
