import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/components/dialog/select_dialog.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void _saveNetworkVideo() async {
    String path =
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    GallerySaver.saveVideo(path);
  }

  Future _downloadImage() async {
    try {
      final result = await GallerySaver.saveImage(widget.imageUrl);
      if (result == true)
        return Fluttertoast.showToast(
          msg: "Đã lưu ảnh!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      return Fluttertoast.showToast(
        msg: "Lỗi khi lưu ảnh!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Lỗi khi lưu ảnh!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print(e);
    }
  }

  onOptionSelect(int index) {
    if (index == 0) {
      return _downloadImage();
    }
    if (index == 1) return _saveNetworkVideo();
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
