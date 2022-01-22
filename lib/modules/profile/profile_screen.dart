import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:snest/models/response/user_response.dart';
import 'profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:snest/modules/splash/splash.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/routes/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snest/shared/shared.dart';
import 'package:snest/api/api.dart';
import 'image_viewer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.find();
  final SplashController authController = Get.find();
  final HomeController homeController = Get.find();
  final ApiRepository apiRepository = Get.find();

  final String? url = Get.parameters['user_url'];

  bool loading = true;
  User? user;

  Future<void> _getUser() async {
    if (url == null) return;
    try {
      setState(() {
        loading = true;
      });

      final res = await apiRepository.getUser(url!);
      print(res.userInfo.cover);
      setState(() {
        user = res;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: user == null
            ? const Text('Trang cá nhân')
            : Text(
                user!.fullname,
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            iconSize: 20,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            iconSize: 20,
          ),
        ],
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavigationBarItem(
            "Trang chủ",
            "icon_home.svg",
          ),
          _buildNavigationBarItem(
            "Khám phá",
            "icon_discover.svg",
          ),
          _buildNavigationBarItem(
            "Tạo",
            "icon_resource.svg",
          ),
          _buildNavigationBarItem(
            "Tin nhắn",
            "icon_inbox.svg",
          ),
          _buildNavigationBarItem(
            "Menu",
            "icon_me.svg",
          )
        ],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: ColorConstants.black,
        selectedItemColor: ColorConstants.black,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        onTap: (index) => print(index),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  height: 400,
                ),
                user?.userInfo.cover == null
                    ? SizedBox()
                    : Hero(
                        child: CachedNetworkImage(
                          imageUrl: user!.userInfo.cover!,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        tag: 'cover_user_$url',
                      ),
                Positioned(
                  top: 210,
                  right: 10,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: user?.avatar == null
                        ? SizedBox()
                        : ClipRRect(
                            child: Hero(
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                  imageUrl: user!.avatar!,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                onTap: () => Get.to(
                                  () => ImageViewer(
                                      imageUrl: user!.avatar!,
                                      tag: 'avatar_user_$url'),
                                ),
                              ),
                              tag: 'avatar_user_$url',
                            ),
                            borderRadius: BorderRadius.circular(75),
                          ),
                  ),
                  top: 150,
                  left: MediaQuery.of(context).size.width / 2 - 75,
                ),
                Positioned(
                  top: 270,
                  left: MediaQuery.of(context).size.width / 2 + 30,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
            Text(url ?? 'Null'),
            TextButton(
              onPressed: () {
                Get.toNamed(
                  '${Routes.HOME}${Routes.PROFILE}/96e98bc5-eb75-34f3-9e56-5ff33004af06',
                );
              },
              child: Text(
                '96e98bc5-eb75-34f3-9e56-5ff33004af06',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(
                  '${Routes.HOME}${Routes.PROFILE}/65c60f3e-9228-313c-bdd2-ec249c023113',
                );
              },
              child: Text(
                '65c60f3e-9228-313c-bdd2-ec249c023113',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.HOME);
              },
              child: Text(
                'ToHome',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(String label, String svg) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/svgs/$svg'),
      label: label,
    );
  }
}
