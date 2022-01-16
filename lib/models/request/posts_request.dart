import 'dart:convert';

enum PostPrivacyValue { public, private, friend }

class CreatePostRequest {
  CreatePostRequest({
    this.content,
    this.privacy = PostPrivacyValue.public,
  });

  String? content;
  PostPrivacyValue privacy;

  factory CreatePostRequest.fromRawJson(String str) =>
      CreatePostRequest.fromJson(
        json.decode(str),
      );

  String toRawJson() => json.encode(toJson());

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    late PostPrivacyValue privacy;
    if (json['privacy'] == 1) {
      privacy = PostPrivacyValue.public;
    } else if (json['privacy'] == 3) {
      privacy = PostPrivacyValue.private;
    } else if (json['privacy'] == 2) {
      privacy = PostPrivacyValue.friend;
    } else {
      privacy = PostPrivacyValue.public;
    }
    return CreatePostRequest(
      content: json["content"],
      privacy: privacy,
    );
  }

  Map<String, dynamic> toJson() {
    late String privacyString;
    switch (privacy) {
      case PostPrivacyValue.public:
        privacyString = "1";
        break;
      case PostPrivacyValue.private:
        privacyString = "3";
        break;
      case PostPrivacyValue.friend:
        privacyString = "2";
        break;
    }
    return {
      "content": content,
      'privacy': privacyString,
    };
  }
}
