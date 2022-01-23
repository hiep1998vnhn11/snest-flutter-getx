import 'dart:convert';

class ListFriendResponse {
  List<Friend> friends;
  int total;

  ListFriendResponse({
    this.friends = const [],
    this.total = 0,
  });

  String toRawJson() => json.encode(toJson());

  factory ListFriendResponse.fromJson(Map<String, dynamic> json) =>
      ListFriendResponse(
        friends: List<Friend>.from(
          json['data'].map(
            (x) => Friend.fromJson(x),
          ),
        ),
        total: json['total'],
      );
  Map<String, dynamic> toJson() => {
        "friends": List<dynamic>.from(friends.map((x) => x.toJson())),
        "total": total,
      };
}

class Friend {
  int id;
  String fullname;
  String url;
  String? avatar;

  Friend({
    required this.id,
    required this.fullname,
    required this.url,
    this.avatar,
  });

  factory Friend.fromRawJson(String str) => Friend.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["id"] == null ? 0 : json["id"],
        fullname: json["full_name"] == null ? '' : json["full_name"],
        url: json["url"] == null ? '' : json["url"],
        avatar: json["profile_photo_path"] == null
            ? null
            : json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "url": url,
        "profile_photo_path": avatar,
      };
}
