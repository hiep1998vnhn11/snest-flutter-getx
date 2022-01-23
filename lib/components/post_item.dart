import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/modules/home/home_controller.dart';
// import 'package:snest/screens/post/post.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:snest/components/reaction/data/example_data.dart' as example;
import 'package:snest/components/reaction/reaction_builder.dart';
import 'package:snest/models/models.dart' show Post;
import 'post_media_grid.dart';
import 'package:snest/components/app_avatar.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final Function(int, String?) onLike;
  final Function() onOptions;
  final Function() onShare;
  final Function() onDetail;

  final HomeController authController = Get.find();

  PostItem({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onOptions,
    required this.onShare,
    required this.onDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: AppAvatar(
                imageUrl: post.userAvatar,
                showOnline: false,
                size: 40,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              title: Text(
                post.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 20,
                ),
                onPressed: onOptions,
              ),
              subtitle: Row(children: [
                Text(post.createdAt),
                const Text(' . '),
                _buildPrivacy(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(post.content ?? ''),
            ),
            PostMediaGrid(media: post.media, onTap: onDetail),
            ReactionBuilder.buildLikeGroup(post.likeGroup, post.likesCount),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .25,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ReactionButtonToggle<String>(
                        onReactionChanged: (String? value, bool isChecked) {
                          onLike(post.id, value);
                        },
                        reactions: example.reactions,
                        initialReaction: example.defaultInitialReaction,
                        selectedReaction: example.reactions[
                            post.likeStatus == null || post.likeStatus == 0
                                ? 0
                                : post.likeStatus! - 1],
                        isChecked:
                            post.likeStatus != null && post.likeStatus != 0,
                      ),
                    ),
                  ),
                  InkWell(
                    // onTap: () => Get.to(
                    //   () => PostScreen(
                    //     id: id,
                    //     privacy: privacy,
                    //     avatar: avatar,
                    //     name: name,
                    //     content: content,
                    //     pid: pid,
                    //   ),
                    // ),
                    onTap: onDetail,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Icon(
                          //   Icons.mode_comment_outlined,
                          //   size: 20,
                          //   color: Colors.grey[600],
                          // ),
                          Image.asset(
                            'assets/icons/comment.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Bình luận',
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onShare,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/icons/share.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Chia sẻ',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 8,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildPrivacy() {
    if (post.privacy == 1) {
      return const Icon(
        Icons.public,
        size: 16,
        color: Colors.grey,
      );
    } else if (post.privacy == 2) {
      return const Icon(
        Icons.supervised_user_circle,
        size: 15,
        color: Colors.grey,
      );
    } else if (post.privacy == 3) {
      return const Icon(
        Icons.lock_outline,
        size: 15,
        color: Colors.grey,
      );
    } else {
      return const Icon(
        Icons.public,
        size: 15,
        color: Colors.grey,
      );
    }
  }
}
