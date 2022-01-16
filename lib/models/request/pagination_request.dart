import 'dart:convert';

class PaginationRequest {
  PaginationRequest({this.limit = 10, this.offset = 0, this.searchKey});

  int offset;
  int limit;
  String? searchKey;

  factory PaginationRequest.fromRawJson(String str) =>
      PaginationRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginationRequest.fromJson(Map<String, dynamic> json) =>
      PaginationRequest(
        offset: json["offset"] ?? 0,
        limit: json["limit"] ?? 10,
        searchKey: json["searchKey"],
      );

  Map<String, dynamic> toJson() => {
        "offset": '$offset',
        "limit": '$limit',
        "searchKey": searchKey,
      };
}
