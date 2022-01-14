import 'package:flutter/material.dart';
import 'package:snest/shared/shared.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: SizeConfig().screenWidth * 0.26,
            height: SizeConfig().screenWidth * 0.26,
            image: AssetImage('assets/icons/wow.png'),
            fit: BoxFit.contain,
          ),
          Text(
            'Đang tải ...',
            style: TextStyle(fontSize: 30.0),
          ),
        ],
      ),
    );
  }
}
