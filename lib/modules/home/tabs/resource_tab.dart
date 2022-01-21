import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snest/modules/home/home_controller.dart';
import 'package:snest/modules/splash/splash_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:video_player/video_player.dart';
import 'package:snest/components/video.dart';
import 'post/post_privacy.dart';
import 'dart:async';
import 'dart:io';
import 'package:snest/models/request/posts_request.dart' show PostPrivacyValue;
import 'package:snest/api/api_provider.dart';

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class ResourceTab extends StatefulWidget {
  const ResourceTab({Key? key}) : super(key: key);

  @override
  _ResourceTabState createState() => _ResourceTabState();
}

class _ResourceTabState extends State<ResourceTab> {
  final HomeController controller = Get.find();
  final SplashController authController = Get.find();
  bool _isLoading = false;
  bool _isDisabled = false;
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
    if (_isDisabled || _isLoading) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final id = await controller.createPost(content: content);
      if (_imageFileList != null) {
        for (final file in _imageFileList!) {
          await ApiProvider.uploadFile(
            file: file,
            objectId: id,
            objectType: 'post',
          );
        }
      }
      _toastSuccess('Đăng bài viết thành công!');
    } catch (e) {
      print(e);
      _toastError('Hãy điền nội dung hoặc đăng tải một ảnh hoặc video');
    } finally {
      setState(() {
        _isLoading = false;
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
      try {
        final pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
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
      return Column(children: [
        ..._imageFileList!.map(
          (image) => InkWell(
            onTap: () => _showPreviewImageOrVideo(
              context: context,
              file: image,
            ),
            child: kIsWeb
                ? Image.network(image.path)
                : Image.file(File(image.path)),
          ),
        ),
      ]);
    } else if (_pickImageError != null) {
      return Text(
        'Chọn hình ảnh bị lỗi: $_pickImageError, Hãy thử chọn ảnh khác! ',
        textAlign: TextAlign.center,
      );
    } else {
      return const SizedBox();
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

  @override
  void initState() {
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
            onPressed: _createPost,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  )
                : Text('Đăng'),
            style: TextButton.styleFrom(
              primary: Colors.blue,
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
                              () => authController.currentUser.value?.avatar ==
                                      null
                                  ? const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets.images/default.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        authController
                                            .currentUser.value!.avatar!,
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
                                      authController
                                              .currentUser.value?.fullname ??
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
                                        onPressed: () async {
                                          final PostPrivacyValue? value =
                                              await Get.to(
                                            () => PostPrivacy(
                                              value: PostPrivacyValue.public,
                                            ),
                                          );
                                          print(value);
                                        },
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
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          cursorColor: Colors.lightBlue,
                          maxLines: 20,
                          minLines: 1,
                          style: TextStyle(fontSize: 16),
                          onChanged: (String value) => setState(
                            () {
                              content = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: !kIsWeb &&
                            defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                            future: retrieveLostData(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<void> snapshot,
                            ) {
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
                      isMultiImage: true,
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

  _showPreviewImageOrVideo({
    required BuildContext context,
    required XFile file,
    bool isVideo = false,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: NavigationBar(
            height: 60,
            backgroundColor: Colors.black,
            destinations: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  InkWell(
                    child: kIsWeb
                        ? Image.network(file.path)
                        : Image.file(
                            File(file.path),
                          ),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showSelectPrivacyDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            leading: IconButton(
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Đối tượng của bài viết'),
          ),
          body: Column(
            children: [
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Text(
                      'Ai có thể xem bài viết này?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Bài viết của bạn sẽ hiển thị trên Bảng tin, trang cá nhân và kết quả tìm kiếm',
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Đối tượng mặc định của bạn đang là '),
                          TextSpan(
                            text: 'Công khai.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Tuy nhiên, bạn có thể chọn đối tượng khác.',
                          ),
                        ],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Chọn đối tượng:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: '1',
                      groupValue: privacy,
                      onChanged: (String? value) {
                        setState(() {
                          privacy = value!;
                        });
                      },
                    ),
                    Radio(
                      value: '2',
                      groupValue: privacy,
                      onChanged: (String? value) {
                        setState(() {
                          privacy = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                  boxShadow: [],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
