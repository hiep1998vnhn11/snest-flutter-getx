import 'dart:convert';
import 'package:snest/util/format/date.dart';
import 'user_response.dart' show CompressUser;
import 'posts_response.dart' show LikeGroup;

class ListCommentResponse {
  List<Comment> comments;

  ListCommentResponse({
    this.comments = const [],
  });

  String toRawJson() => json.encode(toJson());

  factory ListCommentResponse.fromJson(List<dynamic> json) =>
      ListCommentResponse(
        comments: List<Comment>.from(
          json.map(
            (x) => Comment.fromJson(x),
          ),
        ),
      );
  Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    required this.id,
    this.content,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.likeStatus,
    this.likeGroup = const [],
    this.imagePath,
    this.subCommentsCount = 0,
    required this.user,
  });

  int id;
  String? content;
  int? likeStatus;
  int likesCount;
  List<LikeGroup> likeGroup;
  String createdAt;
  String? updatedAt;
  String? imagePath;
  int subCommentsCount;
  CompressUser user;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"] ?? '',
        createdAt: FormatDate.formatTimeAgo(json["created_at"]),
        updatedAt: FormatDate.formatTimeAgo(json["updated_at"]),
        likesCount: json["liked_count"] ?? 0,
        likeStatus: json["likeStatus"],
        likeGroup: List<LikeGroup>.from(
          json["like_group"].map(
            (x) => LikeGroup.fromJson(x),
          ),
        ),
        user: CompressUser.fromJson(
          json["user"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "likes_count": likesCount,
        "likeStatus": likeStatus,
        "like_group": List<dynamic>.from(
          likeGroup.map((x) => x.toJson()),
        ),
        "user": user.toJson(),
      };
}
