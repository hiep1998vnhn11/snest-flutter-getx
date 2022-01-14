import 'package:flutter/material.dart';
import 'package:snest/modules/auth/auth.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
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
            'Sign Up',
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
      key: controller.registerFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputField(
              controller: controller.registerEmailController,
              keyboardType: TextInputType.text,
              labelText: 'Email hoặc số điện thoại',
              placeholder: 'Email hoặc số điện thoại',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập email hoặc số điện thoại';
                }
                return null;
              },
            ),
            CommonWidget.rowHeight(),
            InputField(
              controller: controller.registerPasswordController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Mật khẩu',
              placeholder: 'Mật khẩu của bạn',
              password: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy nhập mật khẩu.';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự.';
                }
                return null;
              },
            ),
            CommonWidget.rowHeight(),
            InputField(
              controller: controller.registerConfirmPasswordController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Xác nhận mật khẩu',
              placeholder: 'Xác nhận mật khẩu',
              password: true,
              validator: (value) {
                if (controller.registerPasswordController.text !=
                    controller.registerConfirmPasswordController.text) {
                  return 'Xác nhận mật khẩu không đúng';
                }
                return null;
              },
            ),
            CommonWidget.rowHeight(height: 10.0),
            AppCheckbox(
              label: 'Chấp nhận điều khoản dịch vụ',
              checked: controller.registerTermsChecked,
              onChecked: (val) {
                controller.registerTermsChecked = val!;
              },
            ),
            CommonWidget.rowHeight(height: 80),
            BorderButton(
              text: 'Đăng ký',
              backgroundColor: Colors.white,
              onPressed: () {
                controller.register(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
