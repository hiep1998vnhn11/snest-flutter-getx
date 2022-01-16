import 'dart:math';

import 'package:snest/api/api.dart';
import 'package:snest/models/response/users_response.dart';
import 'package:snest/models/response/user_response.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/shared/shared.dart';
import 'package:snest/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tabs/darhboard/dashboard.dart';

class HomeController extends GetxController {
  final ApiRepository apiRepository;
  HomeController({required this.apiRepository});

  var currentTab = MainTabs.home.obs;
  var users = Rxn<UsersResponse>();
  var user = Rxn<Datum>();
  var currentUser = Rxn<CurrentUser>();
  var stories = Rx<List<String>>([
    'Story 1',
    'Story 2',
    'Story 3',
    'Story 4',
    'Story 5',
    'Story 6',
    'Story 7',
    'Story 8',
  ]);

  late MainTab mainTab;
  late DiscoverTab discoverTab;
  late ResourceTab resourceTab;
  late InboxTab inboxTab;
  late MeTab meTab;

  @override
  void onInit() async {
    super.onInit();
    mainTab = MainTab();
    discoverTab = DiscoverTab();
    resourceTab = ResourceTab();
    inboxTab = InboxTab();
    meTab = MeTab();
    await getUserInfo();
  }

  Future<void> loadUsers() async {
    // var _users = await apiRepository.getUsers();
    // if (_users!.data!.length > 0) {
    //   users.value = _users;
    //   users.refresh();
    //   _saveUserInfo(_users);
    // }
  }

  void signout() {
    var prefs = Get.find<SharedPreferences>();
    prefs.clear();
    Get.toNamed(Routes.AUTH);
  }

  Future<void> getUserInfo() async {
    try {
      final user = await apiRepository.me();
      print('fetchUser');
      currentUser.value = user;
    } catch (e) {
      print(e);
    }
  }

  void switchTab(index) {
    var tab = _getCurrentTab(index);
    currentTab.value = tab;
  }

  int getCurrentIndex(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return 0;
      case MainTabs.discover:
        return 1;
      case MainTabs.resource:
        return 2;
      case MainTabs.inbox:
        return 3;
      case MainTabs.me:
        return 4;
      default:
        return 0;
    }
  }

  MainTabs _getCurrentTab(int index) {
    switch (index) {
      case 0:
        return MainTabs.home;
      case 1:
        return MainTabs.discover;
      case 2:
        return MainTabs.resource;
      case 3:
        return MainTabs.inbox;
      case 4:
        return MainTabs.me;
      default:
        return MainTabs.home;
    }
  }

  Future getStory() async {
    stories.value.add('Story ${stories.value.length}');
  }
}
