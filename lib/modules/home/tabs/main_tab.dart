import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snest/models/models.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/components/app_avatar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snest/components/post_item.dart';
import 'package:snest/modules/modules.dart';
// import 'package:snest/models/request/posts_request.dart' show PostPrivacyValue;
import 'post/post_privacy.dart';
import 'package:snest/components/shimmer/post_item_shimmer.dart';

class MainTab extends GetView<HomeController> {
  final SplashController authController = Get.find();

  void _onRefresh() async {
    await controller.getPosts(isRefresh: true);
    controller.refreshController.refreshCompleted();
  }

  void _onLoading() async {
    try {
      await controller.getPosts(isRefresh: false);
      controller.refreshController.loadComplete();
    } catch (e) {
      print(e);
      controller.refreshController.loadNoData();
    }
  }

  Future<void> _handleLike(int postId, String? likeStatus) async {
    try {
      final int index = controller.posts.value.indexWhere(
        (post) => post.id == postId,
      );
      if (index == -1) return;
      var post = controller.posts.value[index];
      final intLikeStatus = likeStatus == null ? 0 : int.parse(likeStatus);
      final likeStatusBefore = post.likeStatus;
      post.likeStatus = intLikeStatus;
      if (intLikeStatus > 0 && likeStatusBefore == 0) post.likesCount++;
      if (intLikeStatus == 0 && likeStatusBefore > 0) post.likesCount--;
      final indexLikeStatus =
          post.likeGroup.indexWhere((like) => like.status == intLikeStatus);
      final indexStatusBefore =
          post.likeGroup.indexWhere((like) => like.status == likeStatusBefore);
      if (indexStatusBefore > -1) {
        post.likeGroup[indexStatusBefore].counter--;
        if (post.likeGroup[indexStatusBefore].counter == 0)
          post.likeGroup.removeAt(indexStatusBefore);
      }
      if (indexLikeStatus == -1 && intLikeStatus > 0) {
        if (post.likeGroup.length < 3)
          post.likeGroup.add(
            LikeGroup(status: intLikeStatus, counter: 1),
          );
      }
      if (indexLikeStatus > -1) {
        post.likeGroup[indexLikeStatus].counter++;
      }
      controller.updatePost(index, post);

      controller.apiRepository.handleLikePost(
        pid: post.uid,
        status: intLikeStatus,
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: SizedBox(
            child: Image(
              image: AssetImage('assets/icons/wow.png'),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Get.toNamed('/search');
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/icons/messager.png',
              width: 20,
            ),
          ),
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          child: ListView(
            children: [
              _buildAction(),
              Container(
                height: 8,
                color: Colors.grey[300],
              ),
              _buildListStory(),
              Container(
                height: 8,
                color: Colors.grey[300],
              ),
              _buildListPost(),
              controller.loadingPost.value ? PostItemShimmer() : SizedBox(),
            ],
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          header: const WaterDropMaterialHeader(),
          controller: controller.refreshController,
          footer: CustomFooter(
            builder: _buildCustomFooter,
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: controller.postCount.value,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final post = controller.posts.value[index];
    return PostItem(
      post: post,
      onLike: _handleLike,
      onOptions: () => _showOptionDialog(context),
      onShare: () => _showShareDialog(context),
      onDetail: () => controller.toPostDetail(post),
    );
  }

  Widget _buildListStory() {
    return Container(
      height: 200,
      color: Colors.white,
      child: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          scrollDirection: Axis.horizontal,
          itemBuilder: _buildStoryItem,
          itemCount: controller.storiesCount.value,
        ),
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, int index) {
    final story = controller.stories.value[index];
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8, left: 4, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppAvatar(
                imageUrl: 'https://reqres.in/img/faces/1-image.jpg',
                size: 35,
                showOnline: false,
              ),
              Text(
                story,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/cm0.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Widget _buildAction() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: authController.currentUser.value?.avatar,
                  size: 40,
                  borderWidth: 1,
                  borderColor: Colors.grey[0],
                  isOnline: true,
                  onlineDotSize: 6,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () =>
                          controller.currentTab.value = MainTabs.resource,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bạn đang nghĩ gì?',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.grey.shade800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Ảnh'),
                    ],
                  ),
                  onPressed: () {},
                ),
                flex: 1,
              ),
              VerticalDivider(),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.grey.shade800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Ảnh'),
                    ],
                  ),
                  onPressed: () {},
                ),
                flex: 1,
              ),
              VerticalDivider(),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.grey.shade800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Ảnh'),
                    ],
                  ),
                  onPressed: () {},
                ),
                flex: 1,
              ),
            ],
          )
        ],
      ),
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
                            AppAvatar(
                              imageUrl:
                                  authController.currentUser.value?.avatar,
                              size: 40,
                              borderWidth: 1,
                              borderColor: Colors.grey[0],
                              isOnline: true,
                              onlineDotSize: 6,
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

  Widget _buildCustomFooter(BuildContext context, LoadStatus? mode) {
    Widget body;
    if (mode == LoadStatus.idle) {
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
}
