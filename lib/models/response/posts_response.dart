import 'dart:convert';

class ListPostResponse {
  List<Post> posts;

  ListPostResponse({
    this.posts = const [],
  });

  String toRawJson() => json.encode(toJson());

  factory ListPostResponse.fromJson(Map<String, dynamic> json) =>
      ListPostResponse(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
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
    this.createdAt,
    this.updatedAt,
    required this.userName,
    required this.userUrl,
    this.userAvatar,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.likeStatus,
    this.imagesCount = 0,
    this.likeGroup = const [],
  });

  int id;
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
  String? createdAt;
  String? updatedAt;

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        content: json["content"],
        privacy: json["privacy"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        userUrl: json["user_url"],
        userAvatar: json["user_profile_photo_path"],
        commentsCount: json["comments_count"],
        likesCount: json["likes_count"] ?? 0,
        likeStatus: json["like_status"],
        imagesCount: json["images_count"],
        likeGroup: List<LikeGroup>.from(
          json["like_group"].map(
            (x) => LikeGroup.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "privacy": privacy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "user_url": userUrl,
        "user_profile_photo_path": userAvatar,
        "comments_count": commentsCount,
        "likes_count": likesCount,
        "like_status": likeStatus,
        "images_count": imagesCount,
        "like_group": List<dynamic>.from(
          likeGroup.map((x) => x.toJson()),
        ),
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
