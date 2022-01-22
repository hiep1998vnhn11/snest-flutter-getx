import 'package:flutter/material.dart';
import 'package:snest/models/response/posts_response.dart' show PostMedia;
import 'package:cached_network_image/cached_network_image.dart';

class PostMediaGrid extends StatelessWidget {
  final List<PostMedia> media;
  final Function() onTap;
  PostMediaGrid({
    required this.media,
    required this.onTap,
  });

  Widget _buildImage({
    required String url,
    int rowCount = 1,
    required Function() onTap,
  }) {
    final double height = rowCount > 2 ? 200.0 : 250.0;
    return Expanded(
      child: InkWell(
        child: SizedBox(
          height: height,
          child: Hero(
            tag: url,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFirstRow(List<PostMedia> firstRow) {
    return Row(
      children: [
        ...firstRow.map(
          (item) => _buildImage(
            url: item.url,
            rowCount: firstRow.length,
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int length = media.length;
    final List<PostMedia> firstRow =
        length > 0 ? media.sublist(0, length > 2 ? length - 1 : 1) : [];
    final String? lastImage = length > 1 ? media.last.url : null;
    return Column(
      children: [
        _buildFirstRow(firstRow),
        SizedBox(
          height: lastImage == null ? 0 : 5,
        ),
        lastImage == null
            ? SizedBox()
            : Row(
                children: [
                  _buildImage(
                    url: lastImage,
                    onTap: onTap,
                  ),
                ],
              ),
      ],
    );
  }
}
