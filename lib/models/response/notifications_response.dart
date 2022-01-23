import 'dart:convert';
import 'package:snest/util/format/date.dart';
import 'user_response.dart';

class ListNotificationResponse {
  List<SnestNotification> notifications;

  ListNotificationResponse({
    this.notifications = const [],
  });

  String toRawJson() => json.encode(toJson());

  factory ListNotificationResponse.fromJson(List<dynamic> json) =>
      ListNotificationResponse(
        notifications: List<SnestNotification>.from(
          json.map(
            (x) => SnestNotification.fromJson(x),
          ),
        ),
      );
  Map<String, dynamic> toJson() => {
        "notifications": List<dynamic>.from(
          notifications.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class SnestNotification {
  SnestNotification(
      {required this.id,
      required this.createdAt,
      required this.type,
      required this.objectId,
      required this.objectType,
      required this.targetUser,
      required this.title,
      required this.objectUrl,
      this.readAt});

  int id;
  String objectUrl;
  String type;
  String objectType;
  int objectId;
  String title;
  String? readAt;
  String createdAt;
  CompressUser targetUser;

  factory SnestNotification.fromRawJson(String str) =>
      SnestNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SnestNotification.fromJson(Map<String, dynamic> json) {
    return SnestNotification(
      id: json["id"],
      objectId: json["object_id"],
      type: json["type"],
      objectType: json["object_type"],
      createdAt: FormatDate.formatTimeAgo(json["created_at"]),
      readAt: json["read_at"] == null
          ? null
          : FormatDate.formatTimeAgo(json["read_at"]),
      title: json["title"],
      targetUser: CompressUser.fromJson(json["target_user"]),
      objectUrl: json["object_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "object_id": objectId,
        "type": type,
        "object_type": objectType,
        "created_at": createdAt,
        "read_at": readAt == null ? null : readAt,
        "title": title,
        "target_user": targetUser.toJson(),
        "object_url": objectUrl,
      };
}
