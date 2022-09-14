import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/model/dashboardGroup.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../injection_container.dart';
import '../model/entityGroup.dart';

class DashboardController extends GetxController {
  RxList<DashboardGroup> dashboardGroupList =
      List<DashboardGroup>.empty(growable: true).obs;
  RxList<EntityGroup> entityGroupList =
      List<EntityGroup>.empty(growable: true).obs;
  var channel;
  RxList deviceList = [].obs;
  void getDashboardGroup() async {
    String url = 'https://dashboard.livair.io/api/entityGroups/DASHBOARD';
    try {
      var res = await sl<Dio>().get(
        url,
      );
      if (res.statusCode == 200) {
        for (var i in res.data) {
          dashboardGroupList.add(DashboardGroup.fromJson(i));
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void getEntityGroup(String id, String pageSize, String page) async {
    String url =
        'https://dashboard.livair.io:443/api/entityGroup/$id/dashboards?pageSize=$pageSize&page=$page&textSearch=%20&sortProperty=title&sortOrder=ASC';
    try {
      var res = await sl<Dio>().get(
        url,
      );
      if (res.statusCode == 200) {
        for (var i in res.data['data']) {
          entityGroupList.add(EntityGroup.fromJson(i));
        }
        if (res.data['hasNext']) {
          getEntityGroup(id, '10', (int.parse(page) + 1).toString());
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong",
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }


}
