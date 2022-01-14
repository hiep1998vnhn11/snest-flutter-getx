import 'package:flutter/material.dart';
import 'package:snest/modules/auth/auth.dart';
import 'package:snest/routes/routes.dart';
import 'package:snest/shared/shared.dart';
import 'package:get/get.dart';

class AuthScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: _buildItems(context),
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      children: [
        Image(
          width: SizeConfig().screenWidth * 0.26,
          height: SizeConfig().screenWidth * 0.26,
          image: AssetImage('assets/icons/wow.png'),
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20.0),
        Text(
          'Snest',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonConstants.largeText,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Bắt đầu ngay!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonConstants.normalText,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
        ),
        SizedBox(height: 50.0),
        GradientButton(
          text: 'Đăng nhập',
          onPressed: () {
            Get.toNamed(Routes.AUTH + Routes.LOGIN, arguments: controller);
          },
        ),
        SizedBox(height: 20.0),
        BorderButton(
          text: 'Đăng ký',
          onPressed: () {
            Get.toNamed(Routes.AUTH + Routes.REGISTER, arguments: controller);
          },
        ),
        SizedBox(height: 62.0),
      ],
    );
  }
}
