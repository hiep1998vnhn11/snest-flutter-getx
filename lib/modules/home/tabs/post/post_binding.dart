import 'package:get/get.dart';

import 'post_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
      () => PostController(
        apiRepository: Get.find(),
        splashController: Get.find(),
      ),
    );
  }
}
