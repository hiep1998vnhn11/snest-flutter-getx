import 'package:flutter/material.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/modules/home/tabs/tabs.dart';
import 'package:snest/shared/shared.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() => _buildWidget()),
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Center(
        child: _buildContent(controller.currentTab.value),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavigationBarItem(
            "Trang chủ",
            MainTabs.home == controller.currentTab.value
                ? "icon_home_activited.svg"
                : "icon_home.svg",
          ),
          _buildNavigationBarItem(
            "Khám phá",
            MainTabs.discover == controller.currentTab.value
                ? "icon_discover_activited.svg"
                : "icon_discover.svg",
          ),
          _buildNavigationBarItem(
            "Tạo",
            "icon_resource.svg",
          ),
          _buildNavigationBarItem(
            "Tin nhắn",
            MainTabs.inbox == controller.currentTab.value
                ? "icon_inbox_activited.svg"
                : "icon_inbox.svg",
          ),
          _buildNavigationBarItem(
            "Tôi",
            MainTabs.me == controller.currentTab.value
                ? "icon_me_activited.svg"
                : "icon_me.svg",
          )
        ],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: ColorConstants.black,
        currentIndex: controller.getCurrentIndex(controller.currentTab.value),
        selectedItemColor: ColorConstants.black,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        onTap: (index) => controller.switchTab(index),
      ),
    );
  }

  Widget _buildContent(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return controller.mainTab;
      case MainTabs.discover:
        return controller.discoverTab;
      case MainTabs.resource:
        return controller.resourceTab;
      case MainTabs.inbox:
        return controller.inboxTab;
      case MainTabs.me:
        return controller.meTab;
      default:
        return controller.mainTab;
    }
  }

  BottomNavigationBarItem _buildNavigationBarItem(String label, String svg) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/svgs/$svg'),
      label: label,
    );
  }
}
