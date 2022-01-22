import 'dart:convert';

class CurrentUser {
  CurrentUser({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    required this.onlineStatus,
    required this.fullname,
    this.phoneNumber,
    required this.slug,
    required this.url,
    required this.userInfo,
  });

  int id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String fullname;
  String slug;
  String url;
  String? phoneNumber;
  OnlineStatus onlineStatus;
  UserInfo userInfo;

  factory CurrentUser.fromRawJson(String str) =>
      CurrentUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        id: json["id"],
        email: json["email"] ?? null,
        firstName: json["first_name"] ?? null,
        lastName: json["last_name"] ?? null,
        avatar: json["profile_photo_path"],
        onlineStatus: OnlineStatus.fromJson(json["online_status"]),
        fullname: json["full_name"],
        phoneNumber: json["phone_number"] ?? null,
        slug: json["slug"] ?? null,
        url: json["url"],
        userInfo: UserInfo.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "online_status": onlineStatus.toJson(),
        "fullname": fullname,
        "phone_number": phoneNumber,
        "slug": slug,
        "url": url,
        "info": userInfo.toJson(),
      };
}

class UserInfo {
  UserInfo({
    required this.id,
    required this.userId,
    this.gender,
    this.birthday,
    this.cover,
    this.educates = const [],
    this.jobs = const [],
    this.from,
    this.linkToSocial,
    this.liveAt,
    this.locale,
    this.showFrom,
    this.showLiveAt = 1,
    this.story,
    this.storyPrivacy = 'public',
  });

  int id;
  int userId;
  String? gender;
  String? cover;
  String? birthday;
  String? liveAt;
  String? from;
  String? linkToSocial;
  String? story;
  String? storyPrivacy;
  String? locale;
  int showLiveAt;
  int? showFrom;
  List jobs;
  List educates;

  factory UserInfo.fromRawJson(String str) =>
      UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        userId: json["user_id"],
        gender: json['gender'],
        cover: json['profile_background_path'],
        birthday: json['birthday'],
        liveAt: json['live_at'],
        from: json['from'],
        linkToSocial: json['link_to_social'],
        story: json['story'],
        storyPrivacy: json['story_privacy'],
        locale: json['locale'],
        showLiveAt: json['show_live_at'],
        showFrom: json['show_from'],
        jobs: json['jobs'] ?? [],
        educates: json['educates'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        'profile_background_path': cover,
      };
}

class OnlineStatus {
  OnlineStatus({
    this.status,
    this.time,
  });

  String? time;
  bool? status;

  factory OnlineStatus.fromJson(Map<String, dynamic> json) => OnlineStatus(
        time: json['time'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "status": status,
      };
}

class CompressUser {
  CompressUser({
    required this.id,
    required this.url,
    required this.onlineStatus,
    required this.fullname,
    this.avatar,
  });
  int id;
  String url;
  String? avatar;
  String fullname;
  OnlineStatus onlineStatus;
  factory CompressUser.fromJson(Map<String, dynamic> json) => CompressUser(
        id: json["id"],
        url: json["url"],
        onlineStatus: OnlineStatus.fromJson(json["online_status"]),
        fullname: json["full_name"],
        avatar: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "online_status": onlineStatus.toJson(),
        "full_name": fullname,
        "profile_photo_path": avatar,
      };
}

class User {
  User({
    required this.id,
    this.avatar,
    required this.onlineStatus,
    required this.fullname,
    required this.url,
    this.friendsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.friend,
    this.follow,
    required this.userInfo,
  });

  int id;
  String? avatar;
  String fullname;
  String url;
  OnlineStatus onlineStatus;
  int friendsCount;
  int followersCount;
  int followingCount;
  List? friend;
  List? follow;
  UserInfo userInfo;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        avatar: json["profile_photo_path"],
        onlineStatus: OnlineStatus.fromJson(json["online_status"]),
        fullname: json["full_name"],
        url: json["url"],
        friendsCount: json["friends_count"] ?? 0,
        followersCount: json["follows_count"] ?? 0,
        friend: json['friend'] ?? null,
        follow: json['follow'] ?? null,
        followingCount: json["followeds_count"] ?? 0,
        userInfo: UserInfo.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "online_status": onlineStatus.toJson(),
        "fullname": fullname,
        "url": url,
        "friends_count": friendsCount,
        "follows_count": followersCount,
        "followeds_count": followingCount,
        "friend": friend,
        "follow": follow,
        "info": userInfo.toJson(),
      };
}
