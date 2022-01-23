import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snest/models/models.dart' show Friend;
import 'package:get/get.dart';
import 'package:snest/routes/routes.dart';

class FriendList extends StatelessWidget {
  final List<Friend> friends;
  final int total;
  FriendList({
    Key? key,
    required this.friends,
    this.total = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double crossAxisSpacing = 4;
    final double mainAxisSpacing = 8;
    final itemWidth = (screenWidth - 20 - (crossAxisSpacing * 2)) / 3;
    final aspectRatio = 0.618;
    final itemHeight = itemWidth / aspectRatio;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  'Bạn bè',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text('$total người bạn'),
              ],
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text('Tìm bạn bè'),
            ),
            SizedBox(width: 10),
          ],
        ),
        GridView.count(
          primary: false,
          padding: EdgeInsets.all(10),
          crossAxisCount: 3,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: aspectRatio,
          children: [
            for (final friend in friends)
              FriendCard(
                friend: friend,
                width: itemWidth,
                height: itemHeight,
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              child: Text('Xem tất cả bạn bè'),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class FriendCard extends StatelessWidget {
  final Friend friend;
  final double width;
  final double height;
  FriendCard({
    Key? key,
    required this.friend,
    required this.width,
    required this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: friend.avatar != null
                    ? Hero(
                        child: CachedNetworkImage(
                          imageUrl: friend.avatar!,
                          fit: BoxFit.cover,
                          height: height - 45,
                          width: double.infinity,
                        ),
                        tag: 'avatar_user_${friend.url}',
                      )
                    : SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  friend.fullname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Get.toNamed(
            '${Routes.HOME}${Routes.PROFILE}/${friend.url}',
          );
        },
      ),
    );
  }
}
