import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:snest/modules/home/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:video_player/video_player.dart';
import 'package:snest/components/video.dart';
import 'dart:async';
import 'dart:io';

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class ResourceTab extends StatefulWidget {
  const ResourceTab({Key? key}) : super(key: key);

  @override
  _ResourceTabState createState() => _ResourceTabState();
}

class _ResourceTabState extends State<ResourceTab> {
  final HomeController controller = Get.find();
  bool _isLoading = false;
  bool _isDisabled = true;
  String content = '';
  String privacy = '1';
  List images = [];
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  bool loading = false;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  void _toastError(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _toastSuccess(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  Future<void> _createPost() async {
    try {
      setState(() {
        loading = true;
      });
      final Map<String, dynamic> params = {
        'content': content,
        'privacy': privacy
      };
      Navigator.of(context).pop();
    } catch (e) {
      _toastError('Hãy điền nội dung hoặc đăng tải một ảnh hoặc video');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController vController;
      if (kIsWeb) {
        vController = VideoPlayerController.network(file.path);
      } else {
        vController = VideoPlayerController.file(File(file.path));
      }
      _controller = vController;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 1.0;
      await vController.setVolume(volume);
      await vController.initialize();
      await vController.setLooping(true);
      await vController.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
  }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
        label: 'image_picker_example_picked_images',
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add optional parameters'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: maxWidthController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    hintText: "Enter maxWidth if desired"),
              ),
              TextField(
                controller: maxHeightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    hintText: "Enter maxHeight if desired"),
              ),
              TextField(
                controller: qualityController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "Enter quality if desired"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'PICK',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                double? width = maxWidthController.text.isNotEmpty
                    ? double.parse(maxWidthController.text)
                    : null;
                double? height = maxHeightController.text.isNotEmpty
                    ? double.parse(maxHeightController.text)
                    : null;
                int? quality = qualityController.text.isNotEmpty
                    ? int.parse(qualityController.text)
                    : null;
                onPick(width, height, quality);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // _facebookLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text('Tạo bài viết'),
        leading: SizedBox(),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Đăng'),
            style: _isDisabled
                ? TextButton.styleFrom(
                    primary: Colors.grey.shade500,
                  )
                : TextButton.styleFrom(
                    primary: Colors.white,
                  ),
          ),
        ],
      ),
      body: Container(
        child: Column(children: [
          Flexible(
            child: Center(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => controller.currentUser.value?.avatar == null
                                  ? const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets.images/default.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        controller.currentUser.value!.avatar!,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.currentUser.value?.fullname ??
                                          '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.public,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            Text(
                                              'Công khai',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.public,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            Text(
                                              'Công khai',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          decoration: InputDecoration.collapsed(
                            hintText: _buildPlaceholder(),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                          cursorColor: Colors.lightBlue,
                          maxLines: 20,
                          minLines: 1,
                          onChanged: (String value) => setState(
                            () {
                              content = value;
                            },
                          ),
                        ),
                        Center(
                          child: !kIsWeb &&
                                  defaultTargetPlatform ==
                                      TargetPlatform.android
                              ? FutureBuilder<void>(
                                  future: retrieveLostData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<void> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return const Text(
                                          'You have not yet picked an image.',
                                          textAlign: TextAlign.center,
                                        );
                                      case ConnectionState.done:
                                        return _handlePreview();
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                            'Pick image/video error: ${snapshot.error}}',
                                            textAlign: TextAlign.center,
                                          );
                                        } else {
                                          return const Text(
                                            'You have not yet picked an image.',
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                    }
                                  },
                                )
                              : _handlePreview(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
              boxShadow: [],
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    isVideo = false;
                    _onImageButtonPressed(
                      ImageSource.gallery,
                      context: context,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.people_alt, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.tag_faces,
                    color: Colors.amber,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_location_alt,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.menu_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String _buildPlaceholder() {
    if (images.isEmpty && content.isEmpty) {
      return 'Hãy viết gì đó';
    }
    if (images.length == 1 && content.isEmpty) {
      return 'Hãy viết gì đó về bức ảnh này';
    }
    if (images.length > 2 && content.isEmpty) {
      return 'Hãy viết gì đó về những bức ảnh này';
    }
    return '';
  }
}
