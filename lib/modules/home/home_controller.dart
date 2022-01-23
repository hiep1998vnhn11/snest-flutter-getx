import 'package:flutter/material.dart';
import 'package:snest/api/api.dart';
import 'package:snest/models/models.dart';
import 'package:snest/models/response/users_response.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snest/modules/splash/splash_controller.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'tabs/post/post_controller.dart';

class HomeController extends GetxController {
  final ApiRepository apiRepository;
  final SplashController splashController;

  Timer? debounce;
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  HomeController({
    required this.apiRepository,
    required this.splashController,
  });

  var currentTab = MainTabs.home.obs;
  var user = Rxn<Datum>();
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
  var storiesCount = Rx<int>(8);
  var loadingStory = Rx<bool>(false);

  var posts = Rx<List<Post>>([]);
  var currentPost = Rxn<Post>();
  var isDone = Rx<bool>(false);
  var loadingPost = Rx<bool>(false);
  var count = Rx<int>(12);
  var postCount = Rx<int>(0);

  late MainTab mainTab;
  late NotificationTab notificationTab;
  late ResourceTab resourceTab;
  late InboxTab inboxTab;
  late MeTab meTab;

  @override
  void onInit() async {
    super.onInit();
    mainTab = MainTab();
    notificationTab = NotificationTab();
    resourceTab = ResourceTab();
    inboxTab = InboxTab();
    meTab = MeTab();

    scrollController.addListener(_scrollListener);
    getPosts(isRefresh: true);
  }

  Future<void> getPosts({bool isRefresh = false}) async {
    count.value++;
    if (isRefresh == false && isDone.value == true) return;
    try {
      loadingPost.value = true;
      int offset = 0;
      if (isRefresh) {
        offset = 0;
        postCount.value = 0;
        posts.value.clear();
      } else {
        offset = posts.value.length;
      }
      final response = await apiRepository.getPosts(PaginationRequest(
        offset: offset,
        limit: 5,
      ));
      posts.value.addAll(response);
      postCount.value += response.length;
      isDone.value = response.length < 5;
    } catch (e) {
      print(e);
    } finally {
      loadingPost.value = false;
    }
  }

  void toPostDetail(Post post) {
    final PostController postController = Get.put<PostController>(
      PostController(
        apiRepository: Get.find(),
        splashController: Get.find(),
      ),
    );
    postController.post.value = post;
    Get.toNamed('${Routes.HOME}${Routes.POST_DETAIL}/${post.uid}');
    postController.fetchPost();
    postController.fetchComments();
  }

  void _scrollListener() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      if (scrollController.position.pixels + 50 >=
          scrollController.position.maxScrollExtent) {
        if (loadingStory.value) return;
        await Future.delayed(const Duration(milliseconds: 1500));
        loadingStory.value = true;
        stories.value.addAll([
          'Story ${storiesCount.value + 1}',
          'Story ${storiesCount.value + 2}',
          'Story ${storiesCount.value + 3}',
          'Story ${storiesCount.value + 4}',
          'Story ${storiesCount.value + 5}',
        ]);
        storiesCount.value += 5;
        loadingStory.value = false;
      }
    });
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
    posts.value.clear();
    currentPost.value = null;
    splashController.currentUser.value = null;
    stories.value.clear();
    storiesCount.value = 0;
    postCount.value = 0;
    currentTab.value = MainTabs.home;
    Get.toNamed(Routes.AUTH);
  }

  Future<void> createPost({String? content, List<int>? media}) async {
    try {
      final post = await apiRepository.createPost(
        CreatePostRequest(content: content, media: media),
      );
      if (post != null) {
        posts.value.insert(0, post);
        currentTab.value = MainTabs.home;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e);
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
        return 3;
      case MainTabs.resource:
        return 2;
      case MainTabs.inbox:
        return 1;
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
      case 3:
        return MainTabs.discover;
      case 2:
        return MainTabs.resource;
      case 1:
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

  void updatePost(int index, Post post) {
    posts.value[index] = post;
    postCount.refresh();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    debounce?.cancel();
    refreshController.dispose();
  }
}
