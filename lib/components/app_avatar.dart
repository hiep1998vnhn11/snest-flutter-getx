import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final bool isOnline;
  final double onlineDotSize;
  final bool showOnline;

  const AppAvatar({
    Key? key,
    this.imageUrl,
    this.size = 20,
    this.borderRadius = 0,
    this.borderColor,
    this.borderWidth = 0,
    this.isOnline = false,
    this.onlineDotSize = 7,
    this.showOnline = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.white,
          width: borderWidth,
        ),
      ),
      child: Stack(
        children: [
          imageUrl == null
              ? CircleAvatar(
                  radius: size - borderWidth,
                  backgroundImage: AssetImage('assets/icons/wow.png'),
                )
              : ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    height: size,
                    width: size,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Icon(Icons.error),
                  ),
                  borderRadius: BorderRadius.circular(size / 2),
                ),
          showOnline
              ? Positioned(
                  bottom: 0,
                  left: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    height: onlineDotSize + 4,
                    width: onlineDotSize + 4,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        height: onlineDotSize,
                        width: onlineDotSize,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
