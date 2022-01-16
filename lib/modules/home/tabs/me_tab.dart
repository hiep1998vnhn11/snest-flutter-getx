import 'package:flutter/material.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/modules/modules.dart';
import 'package:get/get.dart';

class MeTab extends GetView<HomeController> {
  final SplashController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cài đặt',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
              Obx(() => GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              child: authController.currentUser.value?.avatar !=
                                      null
                                  ? CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        authController
                                            .currentUser.value!.avatar!,
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        'assets/images/facebook.png',
                                      ),
                                    ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authController
                                            .currentUser.value?.fullname ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Xem trang cá nhân của bạn',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (bool? value) {},
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Column(
                        children: const [
                          Text('123123'),
                          Card(
                            child: Text('123'),
                            elevation: 1,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(8),
                                  left: Radius.circular(8),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Edit Profile"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Column(
                        children: [
                          const Text('123123'),
                          const Card(
                            child: Text('123'),
                            elevation: 1,
                          ),
                          const SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(8),
                                  left: Radius.circular(8),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Edit Profile"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                print('123');
                              },
                              child: const Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                    left: Radius.circular(8),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Edit Profil 123g 12y3g 12g3 12g3 g12yu3g12 g12 gyu12g3 u1g312e"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                  ),
                  child: const Text(
                    'Xem thêm',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [Icon(Icons.hearing), Text('Học')],
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_drop_up))
                    ],
                  ),
                  Row(
                    children: const [Text('Open!')],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [Icon(Icons.hearing), Text('Học')],
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.arrow_drop_up))
                    ],
                  ),
                  Row(
                    children: const [Text('Open!')],
                  )
                ],
              ),
              SizedBox(
                height: 40.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: controller.signout,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
