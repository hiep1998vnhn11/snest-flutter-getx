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
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["profile_photo_path"],
        onlineStatus: OnlineStatus.fromJson(json["online_status"]),
        fullname: json["full_name"],
        phoneNumber: json["phone_number"],
        slug: json["slug"],
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
        cover: json['cover'],
        birthday: json['birthday'],
        liveAt: json['live_at'],
        from: json['from'],
        linkToSocial: json['link_to_social'],
        story: json['story'],
        storyPrivacy: json['story_privacy'],
        locale: json['locale'],
        showLiveAt: json['show_live_at'],
        showFrom: json['show_from'],
        jobs: json['jobs'],
        educates: json['educates'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
      };
}

class OnlineStatus {
  OnlineStatus({this.status, this.time = ''});

  String time;
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
