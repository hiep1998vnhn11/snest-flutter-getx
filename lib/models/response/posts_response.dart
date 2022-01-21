import 'dart:convert';
import 'package:snest/util/format/date.dart';
import 'package:snest/util/const.dart';

class ListPostResponse {
  List<Post> posts;

  ListPostResponse({
    this.posts = const [],
  });

  String toRawJson() => json.encode(toJson());

  factory ListPostResponse.fromJson(List<dynamic> json) => ListPostResponse(
        posts: List<Post>.from(
          json.map(
            (x) => Post.fromJson(x),
          ),
        ),
      );
  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
      };
}

class Post {
  Post({
    required this.id,
    this.content,
    this.privacy = 1,
    required this.createdAt,
    this.updatedAt,
    required this.userName,
    required this.userUrl,
    this.userAvatar,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.likeStatus,
    this.imagesCount = 0,
    required this.uid,
    this.likeGroup = const [],
    this.media = const [],
  });

  int id;
  String uid;
  String? content;
  int privacy;
  String userName;
  String? userAvatar;
  String userUrl;
  int imagesCount;
  int? likeStatus;
  int commentsCount;
  int likesCount;
  List<LikeGroup> likeGroup;
  String createdAt;
  String? updatedAt;
  List<PostMedia> media;

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      uid: json["uid"],
      content: json["content"],
      privacy: json["privacy"],
      createdAt: FormatDate.formatTimeAgo(json["created_at"]),
      updatedAt: FormatDate.formatTimeAgo(json["updated_at"]),
      userName: json["user_name"],
      userUrl: json["user_url"],
      userAvatar: json["user_profile_photo_path"],
      commentsCount: json["comments_count"] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      likeStatus: json["likeStatus"],
      imagesCount: json["images_count"] ?? 0,
      media: json["media"] != null
          ? List<PostMedia>.from(
              json["media"].map(
                (x) => PostMedia.fromJson(x),
              ),
            )
          : [],
      likeGroup: List<LikeGroup>.from(
        json["like_group"].map(
          (x) => LikeGroup.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "content": content,
        "privacy": privacy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "user_url": userUrl,
        "user_profile_photo_path": userAvatar,
        "comments_count": commentsCount,
        "likes_count": likesCount,
        "likeStatus": likeStatus,
        "images_count": imagesCount,
        "like_group": List<dynamic>.from(
          likeGroup.map((x) => x.toJson()),
        ),
        "media": List<dynamic>.from(
          media.map((x) => x.toJson()),
        ),
      };
}

class PostMedia {
  PostMedia({required this.url, required this.type});

  String url;
  String type;

  factory PostMedia.fromRawJson(String str) =>
      PostMedia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
        url: '${Constants.storageUrl}${json["url"]}',
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
      };
}

class LikeGroup {
  LikeGroup({required this.status, required this.counter});
  int status;
  int counter;

  factory LikeGroup.fromRawJson(String str) =>
      LikeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LikeGroup.fromJson(Map<String, dynamic> json) => LikeGroup(
        status: json["status"],
        counter: json["counter"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "counter": counter,
      };
}
