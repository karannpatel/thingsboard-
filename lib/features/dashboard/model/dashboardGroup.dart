// To parse this JSON data, do
//
//     final dashboardGroup = dashboardGroupFromJson(jsonString);

import 'dart:convert';

DashboardGroup dashboardGroupFromJson(String str) => DashboardGroup.fromJson(json.decode(str));

String dashboardGroupToJson(DashboardGroup data) => json.encode(data.toJson());

class DashboardGroup {
  DashboardGroup({
    this.id,
    required this.createdTime,
    required this.type,
    required this.name,
    this.ownerId,
    required this.additionalInfo,
    this.configuration,
    required this.ownerIds,
    required this.groupAll,
    required this.edgeGroupAll,
  });

  var id;
  int createdTime;
  String type;
  String name;
  var ownerId;
  var additionalInfo;
  var configuration;
  List ownerIds;
  bool groupAll;
  bool edgeGroupAll;

  factory DashboardGroup.fromJson(Map<String, dynamic> json) => DashboardGroup(
    id: json["id"],
    createdTime: json["createdTime"],
    type: json["type"],
    name: json["name"],
    ownerId: json["ownerId"],
    additionalInfo: json["additionalInfo"],
    configuration: json["configuration"],
    ownerIds: json["ownerIds"],
    groupAll: json["groupAll"],
    edgeGroupAll: json["edgeGroupAll"],
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
    "createdTime": createdTime,
    "type": type,
    "name": name,
    "ownerId": ownerId.toJson(),
    "additionalInfo": additionalInfo.toJson(),
    "configuration": configuration.toJson(),
    "ownerIds": List<dynamic>.from(ownerIds.map((x) => x.toJson())),
    "groupAll": groupAll,
    "edgeGroupAll": edgeGroupAll,
  };
}
