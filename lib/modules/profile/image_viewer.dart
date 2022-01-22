import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/components/dialog/select_dialog.dart';
import 'package:snest/api/api_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageViewer extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const ImageViewer({
    Key? key,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);

  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool showOnly = false;

  final List<String> options = [
    'Lưu ảnh',
    'Sao chép ảnh',
    'Chia sẻ',
    'Tắt thông báo',
    'Xóa ảnh',
  ];

  Future _downloadImage() async {
    try {
      final result = await ApiProvider.downloadImage(widget.imageUrl);
    } catch (e) {
      print(e);
    }
  }

  void onOptionSelect(int index) {
    if (index == 0) {
      _downloadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.9),
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                Hero(
                  tag: widget.tag,
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width,
                    ),
                    onLongPress: () => SelectDialog.showOptionDialog(
                      context: context,
                      options: options,
                      onOptionSelect: onOptionSelect,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
