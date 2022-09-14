// To parse this JSON data, do
//
//     final entityGroup = entityGroupFromJson(jsonString);

import 'dart:convert';

EntityGroup entityGroupFromJson(String str) => EntityGroup.fromJson(json.decode(str));

String entityGroupToJson(EntityGroup data) => json.encode(data.toJson());

class EntityGroup {
  EntityGroup({
    this.id,
    required this.createdTime,
    this.tenantId,
    this.customerId,
    required this.title,
    required this.image,
    this.assignedCustomers,
    required this.mobileHide,
    required this.mobileOrder,
    required this.name,
    this.ownerId,
  });

  var id;
  int createdTime;
  var tenantId;
  dynamic customerId;
  String title;
  String image;
  dynamic assignedCustomers;
  bool mobileHide;
  int mobileOrder;
  String name;
  var ownerId;

  factory EntityGroup.fromJson(Map<String, dynamic> json) => EntityGroup(
    id: json["id"]??"",
    createdTime: json["createdTime"]??"",
    tenantId: json["tenantId"]??"",
    customerId: json["customerId"]??"",
    title: json["title"]??"",
    image: json["image"]??"",
    assignedCustomers: json["assignedCustomers"]??"",
    mobileHide: json["mobileHide"]??false,
    mobileOrder: json["mobileOrder"]??0,
    name: json["name"]??"",
    ownerId: json["ownerId"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id.toJson(),
    "createdTime": createdTime,
    "tenantId": tenantId.toJson(),
    "customerId": customerId,
    "title": title,
    "image": image,
    "assignedCustomers": assignedCustomers,
    "mobileHide": mobileHide,
    "mobileOrder": mobileOrder,
    "name": name,
    "ownerId": ownerId.toJson(),
  };
}

