import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:snest/api/api.dart';
import 'package:snest/components/app_avatar.dart';
import 'package:snest/models/models.dart';
import 'package:snest/util/format/date.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<NotificationTab> {
  final ApiRepository apiRepository = Get.find();

  late TabController _tabController;
  late RefreshController _refreshController;

  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  bool loading = true;
  bool isOver = false;
  List<SnestNotification> notifications = [];
  int notificationCount = 0;

  void _onRefresh() async {
    try {
      setState(() {
        loading = true;
      });
      await _getNotifications();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        await _getNotifications(isRefresh: false);
        _refreshController.loadComplete();
      } catch (e) {
        print(e);
        _refreshController.loadNoData();
      }
    });
  }

  Future _readNotification(int id) async {
    final index =
        notifications.indexWhere((notification) => notification.id == id);
    if (index == -1) return;
    setState(() {
      notifications[index].readAt = '';
    });
    try {
      final res = await apiRepository.readNotification(id);
      setState(() {
        notifications[index].readAt =
            res == null ? null : FormatDate.formatTimeAgo(res);
      });
    } catch (err) {
      print(err);
      setState(() {
        notifications[index].readAt = null;
      });
    }
  }

  Future _getNotifications({bool isRefresh = true}) async {
    final int offset = isRefresh ? 0 : notifications.length;
    if (isRefresh) {
      setState(() {
        notifications.clear();
        notificationCount = 0;
        isOver = false;
      });
    } else if (isOver || loading) return;

    final res = await apiRepository.getNotifications(
      PaginationRequest(
        limit: 20,
        offset: offset,
      ),
    );

    setState(() {
      notifications.addAll(res);
      notificationCount += res.length;
      isOver = res.length < 20;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 40,
        centerTitle: false,
        leading: SizedBox(),
        leadingWidth: 0,
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          onTap: (index) {
            print(index);
          },
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Tất cả'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_active_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Chưa đọc'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: const WaterDropMaterialHeader(),
        controller: _refreshController,
        footer: CustomFooter(
          builder: _buildCustomFooter,
        ),
        child: ListView(
          children: [
            loading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    width: 80,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemCount: 10,
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: _itemBuilder,
                    itemCount: notificationCount,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final notification = notifications[index];
    return ListTile(
      tileColor:
          notification.readAt == null ? Colors.blue.shade100 : Colors.white,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: notification.targetUser.fullname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: ' ' + notification.title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        notification.createdAt,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {},
      ),
      leading: AppAvatar(
        imageUrl: notification.targetUser.avatar,
        size: 50,
        isOnline: notification.targetUser.onlineStatus.status ?? false,
        borderColor: Colors.grey,
        borderWidth: 1,
      ),
      onTap: () {
        _readNotification(notification.id);
      },
    );
  }

  Widget _buildCustomFooter(BuildContext context, LoadStatus? mode) {
    Widget body;

    if (mode == LoadStatus.idle) {
      body = const Text("Kéo xuống để tải thêm");
    } else if (mode == LoadStatus.loading) {
      body = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Container(),
      ); // body = const CupertinoActivityIndicator();
    } else if (mode == LoadStatus.failed) {
      body = const Text("Tải thất bại! Click để thử lại");
    } else if (mode == LoadStatus.canLoading) {
      body = const Text("Thả lên để tải thêm");
    } else {
      if (loading)
        body = Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(),
        );
      else if (isOver)
        body = const Text("Đã tải hết dữ liệu");
      else
        body = const Text("Đã tải hết dữ liệu");
    }
    return SizedBox(
      height: 55.0,
      child: Center(child: body),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
