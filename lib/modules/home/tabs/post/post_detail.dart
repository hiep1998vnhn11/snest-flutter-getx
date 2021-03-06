import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/components/app_avatar.dart';
import 'package:snest/components/reaction/data/example_data.dart' as example;
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:snest/components/reaction/reaction_builder.dart';
import 'package:snest/modules/splash/splash_controller.dart';
import 'post_controller.dart';

class PostScreen extends GetView<PostController> {
  final SplashController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          title: ListTile(
            dense: true,
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/default.png'),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              controller.post.value!.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 20,
                ),
                onPressed: () {}),
            subtitle: Row(
              children: [
                Text(controller.post.value!.createdAt),
                const Text(' . '),
                ReactionBuilder.buildPrivacy(controller.post.value!.privacy),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomAppBar(
            notchMargin: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 14, right: 10, top: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFEEEEEEE),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: controller.commentController,
                              onChanged: (text) {
                                if (text.isEmpty)
                                  controller.showCommentButton.value = false;
                                else
                                  controller.showCommentButton.value = true;
                              },
                              decoration: const InputDecoration.collapsed(
                                hintText: 'H??y vi???t g?? ???? ...',
                              ),
                              focusNode: controller.commentFocusNode,
                              maxLines: 7,
                              minLines: 1,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          controller.showCommentButton.value
                              ? InkWell(
                                  onTap: () {
                                    controller.commentFocusNode.unfocus();
                                    controller.commentController.clear();
                                    controller.showCommentButton.value = false;
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              print('123');
                            },
                            child: const Icon(
                              Icons.tag_faces_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.showCommentButton.value
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send_outlined,
                            color: Colors.blue,
                          ),
                        )
                      : SizedBox(
                          width: 14,
                        ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(controller.post.value?.content ?? ''),
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
                              onTap: () => controller.toPostCompact(),
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
              ReactionBuilder.buildLikeGroup(
                controller.post.value!.likeGroup,
                controller.post.value!.likesCount,
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ReactionButtonToggle<String>(
                          onReactionChanged: (String? value, bool isChecked) =>
                              controller.handleLike(
                            value == null ? 0 : int.parse(value),
                          ),
                          reactions: example.reactions,
                          initialReaction: example.defaultInitialReaction,
                          selectedReaction: example.reactions[
                              controller.post.value!.likeStatus == 0
                                  ? 0
                                  : controller.post.value!.likeStatus - 1],
                          isChecked: controller.post.value!.likeStatus > 0,
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
                              Image.asset('assets/icons/comment.png',
                                  height: 20),
                              const SizedBox(width: 5),
                              const Text('B??nh lu???n'),
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
                              Image.asset('assets/icons/share.png', height: 20),
                              const SizedBox(width: 5),
                              const Text('chia s???'),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                // child: ReactionBuilder.buildLikeGroup(likeGroup, totalLike),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    controller.post.value!.commentsCount == 0
                        ? const Text('B??i vi???t ch??a c?? b??nh lu???n!')
                        : Text(
                            '${controller.post.value!.commentsCount} b??nh lu???n',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: const [
                    Text('B??i vi???t ch??a c?? l?????t chia s??? n??o!'),
                  ],
                ),
              ),
              const Divider(),
              _buildListComment(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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
                    child: Text('??ang vi???t ...'),
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
                                'Th??ch',
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
                                'Ph???n h???i',
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
