import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snest/models/response/users_response.dart';
import 'package:snest/modules/home/home.dart';
import 'package:snest/components/app_avatar.dart';
import 'package:snest/shared/constants/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainTab extends GetView<HomeController> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // await _fetchPost(isRefresh: true);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // final success = await _fetchPost(isRefresh: false);
    final success = true;
    if (success) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
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
            icon: Icon(Icons.message_rounded),
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
              SizedBox(
                height: 6,
              ),
              _buildListStory(),
              _buildListPost(),
            ],
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          header: const WaterDropMaterialHeader(),
          controller: _refreshController,
          footer: CustomFooter(
            builder: _buildCustomFooter,
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return Column(children: [
      ...controller.stories.value.map(
        (post) => SizedBox(
          height: 300,
          child: Text(post),
        ),
      ),
    ]);
  }

  Widget _buildGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: data!.length,
      itemBuilder: (BuildContext context, int index) => Container(
        color: ColorConstants.lightGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${data![index].lastName} ${data![index].firstName}'),
            CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: data![index].avatar ??
                  'https://reqres.in/img/faces/1-image.jpg',
              placeholder: (context, url) => Image(
                image: AssetImage('assets/images/icon_success.png'),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text('${data![index].email}'),
          ],
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _buildListStory() {
    return Container(
      height: 200,
      color: Colors.white,
      child: ListView(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 5,
          ),
          ...controller.stories.value.map(
            (story) => Row(
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
            ),
          ),
        ],
      ),
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
                  imageUrl: controller.currentUser.value?.avatar,
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
                      onPressed: () {},
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

  List<Datum>? get data {
    return controller.users.value == null ? [] : controller.users.value!.data;
  }
}
