import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snest/api/api.dart';
import 'package:snest/models/models.dart';
import 'package:get/get.dart';
import 'package:snest/modules/splash/splash_controller.dart';
import 'package:snest/routes/app_pages.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostController extends GetxController {
  final ApiRepository apiRepository;
  final SplashController splashController;
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  PostController({
    required this.apiRepository,
    required this.splashController,
  });

  var images = Rx<List<PostMedia>>([]);
  var post = Rxn<Post>();
  var comments = Rx<List<Comment>>([]);
  var showCommentButton = Rx(false);
  var commenting = Rx(false);
  var commentCount = Rx(0);
  var isOver = Rx(false);
  var isLoading = Rx(false);
  var isShowFull = Rx(false);

  @override
  void onInit() async {
    super.onInit();
  }

  toggleIsShowFull() {
    isShowFull.value = !isShowFull.value;
  }

  Future<void> fetchPost() async {
    try {
      if (post.value == null) return;
      images.value = post.value!.media;
      final res = await apiRepository.getPost(post.value!.uid);
      if (res == null) return;
      images.value = res.media;
      post.value = res;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fetchComments({bool isRefresh = false}) async {
    if (post.value?.uid == null) return false;
    try {
      isLoading.value = true;
      if (isRefresh) {
        commentCount.value = 0;
        comments.value.clear();
      }
      final listComments = await apiRepository.getComments(
        PaginationRequest(
          offset: commentCount.value,
          limit: 10,
        ),
        post.value!.uid,
      );
      print(listComments);
      if (listComments.length < 10) {
        isOver.value = true;
      }
      comments.value.addAll(listComments);
      commentCount.value += listComments.length;
      // final String url = '/v1/user/post/${widget.pid}/comment';
      // final List<dynamic> res = await HttpService.get(
      //     url, {'offset': '$commentCount', 'limit': '10'});
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onComment() async {
    final String content = commentController.text;
    if (content.isEmpty) return;
    final randomId = Random().nextInt(100000000);
    try {
      //   final comment = {
      //     'content': commentContent,
      //     'id': randomId,
      //     'liked_count': 0,
      //     'user': {
      //       'full_name': authController.user.value['full_name'],
      //       'profile_photo_path': authController.user.value['profile_photo_path'],
      //       'url': authController.user.value['url'],
      //     }
      //   };
      //   commentController.clear();
      //   setState(() {
      //     comments.insert(0, comment);
      //     commentCount += 1;
      //     commentContent = '';
      //   });
      //   final String url = '/v1/user/post/${widget.pid}/comment';
      //   final Map<String, dynamic> res = await HttpService.post(url, {
      //     'content': content,
      //   });
      //   final int index =
      //       comments.indexWhere((comment) => comment['id'] == randomId);
      //   if (index != -1) {
      //     setState(() {
      //       comments[index]['created_at'] = res['created_at'];
      //       comments[index]['id'] = res['id'];
      //     });
      //   }
    } catch (e) {
      // _toastError('Có lỗi xảy ra, xin hãy thử lại sau!');
      // final int index =
      //     comments.indexWhere((comment) => comment['id'] == randomId);
      // if (index != -1) {
      // }
      // print(e);
    }
  }

// void _toastError(String value) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(value),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

  Future<void> onCommentLike(int id) async {
    try {
      // int index = comments.indexWhere((comment) => comment['id'] == id);
      // if (index == -1) return;
      // final int status = comments[index]['like_status'] == null ||
      //         comments[index]['like_status'] == 0
      //     ? 1
      //     : 0;
      // setState(() {
      //   comments[index]['liked_count'] = status == 1
      //       ? comments[index]['liked_count'] + 1
      //       : comments[index]['liked_count'] - 1;
      //   comments[index]['like_status'] = status;
      // });
      // final String url = '/v1/user/post/comment/$id/like';
      // await HttpService.post(url, {'status': '$status'});
    } catch (e) {
      print(e);
    }
  }

  toPostCompact({String? pid}) {
    final postId = pid == null ? post.value?.uid : pid;
    if (postId == null) return;
    return Get.toNamed('${Routes.HOME}${Routes.POST_DETAIL_COMPACT}/$postId');
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
    commentFocusNode.dispose();
    commentController.dispose();
  }
}
