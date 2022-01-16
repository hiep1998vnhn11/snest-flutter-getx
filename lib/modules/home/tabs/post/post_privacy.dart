import 'package:flutter/material.dart';
import 'package:snest/models/request/posts_request.dart' show PostPrivacyValue;

class PostPrivacy extends StatefulWidget {
  const PostPrivacy({
    Key? key,
    this.value = PostPrivacyValue.public,
  }) : super(key: key);

  final PostPrivacyValue value;
  @override
  _PostPrivacyState createState() => _PostPrivacyState();
}

class _PostPrivacyState extends State<PostPrivacy> {
  PostPrivacyValue privacy = PostPrivacyValue.public;

  @override
  void initState() {
    super.initState();
    privacy = widget.value;
  }

  @override
  Widget build(BuildContext context) {
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
                ListTile(
                  onTap: () {
                    setState(() {
                      privacy = PostPrivacyValue.public;
                    });
                  },
                  title: const Text(
                    'Công khai',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: const Text(
                    'Mọi người trên hoặc ngoài Snest',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  leading: Icon(Icons.public),
                  trailing: Radio(
                    value: PostPrivacyValue.public,
                    groupValue: privacy,
                    onChanged: (PostPrivacyValue? value) {
                      setState(() {
                        privacy = value!;
                      });
                    },
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      privacy = PostPrivacyValue.friend;
                    });
                  },
                  title: const Text(
                    'Bạn bè',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: const Text(
                    'Bạn bè của bạn trên Snest',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  leading: Icon(Icons.people),
                  trailing: Radio(
                    value: PostPrivacyValue.friend,
                    groupValue: privacy,
                    onChanged: (PostPrivacyValue? value) {
                      setState(() {
                        privacy = value!;
                      });
                    },
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      privacy = PostPrivacyValue.private;
                    });
                  },
                  title: const Text(
                    'Chỉ mình tôi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: const Text(
                    'Chỉ mình tôi được xem bài viết này',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  leading: Icon(Icons.lock),
                  trailing: Radio(
                    value: PostPrivacyValue.private,
                    groupValue: privacy,
                    onChanged: (PostPrivacyValue? value) {
                      setState(() {
                        privacy = value!;
                      });
                    },
                  ),
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
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                child: Text('Xong'),
                onPressed: () {
                  Navigator.pop(context, privacy);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
