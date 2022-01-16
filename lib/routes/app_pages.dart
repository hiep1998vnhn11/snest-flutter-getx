import 'package:snest/modules/auth/auth.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/modules/home/tabs/post/post_detail.dart';
import 'package:snest/modules/me/cards/cards_screen.dart';
import 'package:snest/modules/modules.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => AuthScreen(),
      binding: AuthBinding(),
      children: [
        GetPage(name: Routes.REGISTER, page: () => RegisterScreen()),
        GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
      ],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      children: [
        GetPage(name: Routes.CARDS, page: () => CardsScreen()),
        GetPage(
          name: '${Routes.POST_DETAIL}/:post_uid',
          page: () => PostScreen(),
        ),
      ],
    ),
  ];
}
