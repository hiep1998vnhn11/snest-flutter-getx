import 'package:flutter/material.dart';
import 'package:snest/util/format/number.dart';
import 'package:snest/models/response/posts_response.dart';

class ReactionBuilder {
  static Widget buildLikeGroup(List<LikeGroup> likeGroup, int totalLike) {
    return likeGroup.isEmpty || totalLike <= 0
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                for (int i = 0; i < likeGroup.length; i++)
                  buildLikeItem(likeGroup[i]),
                SizedBox(
                  width: 4,
                ),
                Text(
                  UtilNumberFormat.formatNumber(totalLike),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
  }

  static Widget buildLikeItem(LikeGroup like) {
    if (like.counter <= 0) return const SizedBox();
    String reaction = 'like';
    if (like.status == 2)
      reaction = 'love';
    else if (like.status == 3)
      reaction = 'care';
    else if (like.status == 4)
      reaction = 'haha';
    else if (like.status == 5)
      reaction = 'wow';
    else if (like.status == 6)
      reaction = 'sad';
    else if (like.status == 7) reaction = 'angry';
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/reactions/$reaction.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static Widget buildPrivacy(int privacy) {
    if (privacy == 1) {
      return const Icon(
        Icons.public,
        size: 16,
        color: Colors.grey,
      );
    } else if (privacy == 2) {
      return const Icon(
        Icons.supervised_user_circle,
        size: 15,
        color: Colors.grey,
      );
    } else if (privacy == 3) {
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
