import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/components/app_avatar.dart';
import 'package:snest/components/reaction/data/example_data.dart' as example;
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:snest/components/reaction/reaction_builder.dart';
import 'package:snest/modules/splash/splash_controller.dart';
import 'post_controller.dart';

class PostDetailCompactScreen extends GetView<PostController> {
  final SplashController authController = Get.find();
  final TextStyle _textStyle = TextStyle(
    fontSize: 14,
    color: Colors.white.withOpacity(0.5),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.9),
              height: MediaQuery.of(context).size.height,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: controller.images.value.map((image) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: image.url,
                                child: GestureDetector(
                                  child: CachedNetworkImage(
                                    imageUrl: image.url,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  // onHorizontalDragCancel: () => Get.back(),
                                  onTap: () => controller.toggleIsShowFull(),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: IconButton(
                                    icon: image.type == 'image'
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border_outlined),
                                    onPressed: () {
                                      image.type = 'image2';
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            controller.isShowFull.value
                ? Positioned(
                    top: 40,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                : Container(),
            controller.isShowFull.value
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                controller.post.value!.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                controller.post.value!.createdAt,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: _buildCompactContent(
                                  controller.post.value?.content,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ReactionBuilder.buildLikeGroup(
                                    controller.post.value!.likeGroup,
                                    controller.post.value!.likesCount,
                                  ),
                                  Text(
                                    '${controller.post.value!.commentsCount} bình luận',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.white60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ReactionButtonToggle<String>(
                                    onReactionChanged:
                                        (String? value, bool isChecked) {},
                                    reactions: example.reactions,
                                    initialReaction:
                                        example.defaultInitialReaction,
                                    selectedReaction: example.reactions[1],
                                    isChecked: false,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => {},
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/comment.png',
                                          height: 20,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Bình luận',
                                          style: _textStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        'Share image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/share.png',
                                          height: 20,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'chia sẻ',
                                          style: _textStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            height: 1,
                            color: Colors.white60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      color: Colors.black,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  TextSpan _buildCompactContent(String? content) {
    if (content == null) return const TextSpan();
    final isLarge = content.length > 50;
    return TextSpan(
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          print('Privacy Policy"');
        },
      children: [
        TextSpan(
          text: isLarge ? content.substring(0, 50) + '...' : content,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        isLarge
            ? TextSpan(
                text: ' Xem thêm',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14,
                ),
              )
            : const TextSpan(),
      ],
    );
  }

  Widget _buildListComment(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemBuilder: _buildCommentItem,
        itemCount: controller.commentCount.value,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, int index) {
    final comment = controller.comments.value[index];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 10,
        ),
        AppAvatar(
          imageUrl: comment.user.avatar,
          size: 35,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 70,
              decoration: const BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.fullname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        comment.content ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
            ),
            comment.createdAt == null
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Đang viết ...'),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment.createdAt,
                              style: const TextStyle(fontSize: 14),
                            ),
                            TextButton(
                              child: Text(
                                'Thích',
                                style: TextStyle(
                                  color: comment.likeStatus == 0 ||
                                          comment.likeStatus == null
                                      ? Colors.black
                                      : Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {
                                controller.onCommentLike(comment.id);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Phản hổi',
                                style: TextStyle(
                                  color: comment.likeStatus != null
                                      ? Colors.blue
                                      : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        comment.likesCount > 0
                            ? Row(
                                children: [
                                  Text('${comment.likesCount}'),
                                  const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/reactions/like.png'),
                                    radius: 8,
                                  ),
                                ],
                              )
                            : Row(),
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  border() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
}
