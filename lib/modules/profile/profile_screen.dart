import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:snest/models/response/user_response.dart';
import 'package:snest/modules/home/tabs/post/post_controller.dart';
import 'profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:snest/modules/splash/splash.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/routes/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snest/shared/shared.dart';
import 'package:snest/api/api.dart';
import 'image_viewer.dart';
import 'package:snest/models/models.dart';
import 'widget/friend_list.dart';
import 'package:snest/components/post_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snest/models/request/posts_request.dart' show PostPrivacyValue;
import 'package:snest/modules/home/tabs/post/post_privacy.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.find();
  final SplashController authController = Get.find();
  final HomeController homeController = Get.find();
  final ApiRepository apiRepository = Get.find();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  final String? url = Get.parameters['user_url'];
  Timer? _debounce;

  bool loading = true;
  bool loadingFriend = true;
  User? user;
  List<Friend> friends = [];
  int totalFriends = 0;
  List<Post> posts = [];
  int totalPosts = 0;
  bool isOver = false;
  bool loadingPost = true;

  Future<void> _getUser() async {
    if (url == null) return;
    try {
      setState(() {
        loading = true;
      });
      final res = await apiRepository.getUser(url!);
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

  Future<void> _handleLike(int postId, String? likeStatus) async {
    try {
      final int index = posts.indexWhere(
        (post) => post.id == postId,
      );
      if (index == -1) return;
      var post = posts[index];
      post.content = '123123';
      print(post.content);
      posts[index] = post;
    } catch (err) {
      print(err);
    }
  }

  Future<void> _getPosts({bool isRefresh = true}) async {
    if (url == null || isOver) return;
    int offset = totalPosts;
    setState(() {
      if (isRefresh) {
        totalPosts = 0;
        posts.clear();
        isOver = false;
        offset = 0;
      }
    });
    final res = await apiRepository.getUserPosts(
      url: url!,
      request: PaginationRequest(
        limit: 5,
        offset: offset,
      ),
    );
    setState(() {
      posts.addAll(res);
      totalPosts += res.length;
      if (res.length < 5) isOver = true;
    });
  }

  void _onLoading() async {
    //debounce
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () async {
      try {
        setState(() {
          loadingPost = true;
        });
        await _getPosts(isRefresh: false);
        refreshController.loadComplete();
      } catch (e) {
        print(e);
        refreshController.loadNoData();
      } finally {
        setState(() {
          loadingPost = false;
        });
      }
    });
  }

  Future<void> _getFriends() async {
    if (url == null) return;
    try {
      setState(() {
        loadingFriend = true;
      });

      final res = await apiRepository.getFriends(
          url: url!,
          request: PaginationRequest(
            page: 1,
            limit: 6,
          ));
      if (res == null) return;
      setState(() {
        friends = res.friends;
        totalFriends = res.total;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loadingFriend = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getFriends();
    // _getPosts();
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
        onTap: (index) {
          Get.toNamed(Routes.HOME);
          homeController.switchTab(index);
        },
      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        onLoading: _onLoading,
        header: const WaterDropMaterialHeader(),
        controller: refreshController,
        footer: CustomFooter(
          builder: _buildCustomFooter,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 320,
                  ),
                  user?.userInfo.cover == null
                      ? SizedBox()
                      : Hero(
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: user!.userInfo.cover!,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                            onTap: () => Get.to(
                              () => ImageViewer(
                                imageUrl: user!.userInfo.cover!,
                                tag: 'cover_user_$url',
                              ),
                            ),
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
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      user?.fullname ?? '',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildProfileButton(),
                    const Divider(
                      color: Colors.black87,
                    ),
                    _buildProfileInfo(),
                    const Divider(
                      color: Colors.black87,
                    ),
                    FriendList(friends: friends, total: totalFriends),
                    const Divider(
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              _buildListPost(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: totalPosts,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final post = posts[index];
    return PostItem(
      post: post,
      onLike: _handleLike,
      onOptions: () => _showOptionDialog(context),
      onShare: () => _showShareDialog(context),
      onDetail: () => homeController.toPostDetail(post),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(String label, String svg) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/svgs/$svg'),
      label: label,
    );
  }

  Widget _buildProfileButton() {
    if (url == authController.currentUser.value?.url) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Text(
                    'Thêm vào tin',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.black),
                        Text(
                          'Chỉnh sửa trang cá nhân',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Flexible(
            child: TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.black),
                  Text(
                    'Bạn bè',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey.shade300),
            ),
            child: Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        user?.userInfo.showLiveAt == 1
            ? Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Sống tại ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    user?.userInfo.liveAt ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(
          height: 5,
        ),
        user?.userInfo.showFrom == 1
            ? Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Đến từ ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    user?.userInfo.from ?? '',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 22,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  url == authController.currentUser.value?.url
                      ? 'Xem thông tin giới thiệu của bạn'
                      : 'Xem thông tin giới thiệu của ${user?.fullname}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              child: Text('Chỉnh sửa chi tiết công khai'),
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade50,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCustomFooter(BuildContext context, LoadStatus? mode) {
    Widget body;
    if (isOver) {
      body = const Text("Đã tải hết dữ liệu");
    } else if (mode == LoadStatus.idle) {
      body = const Text("Kéo xuống để tải thêm");
    } else if (mode == LoadStatus.loading) {
      body = const CupertinoActivityIndicator();
    } else if (mode == LoadStatus.failed) {
      body = const Text("Tải thất bại! Click để thử lại");
    } else if (mode == LoadStatus.canLoading) {
      body = const Text("Thả lên để tải thêm");
    } else {
      body = const Text("Đã tải hết dữ liệu");
    }
    return SizedBox(
      height: 55.0,
      child: Center(child: body),
    );
  }

  _showOptionDialog(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: 300,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Chỉnh sửa'),
                  onTap: () {},
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Chỉnh sửa'),
                  onTap: () {},
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Chỉnh sửa'),
                  onTap: () {},
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Chỉnh sửa'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showShareDialog(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: 450,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            authController.currentUser.value?.avatar == null
                                ? const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      'assets.images/default.png',
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      authController.currentUser.value!.avatar!,
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authController
                                            .currentUser.value?.fullname ??
                                        '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 130,
                                        child: TextButton(
                                          onPressed: () async {
                                            final PostPrivacyValue? value =
                                                await Get.to(
                                              () => PostPrivacy(
                                                value: PostPrivacyValue.public,
                                              ),
                                            );
                                            print(value);
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.public,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                              Text(
                                                'Công khai',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.open_in_full,
                            size: 16,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debounce?.cancel();
    refreshController.dispose();
    super.dispose();
  }
}
