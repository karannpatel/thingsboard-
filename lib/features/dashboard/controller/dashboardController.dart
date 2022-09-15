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
  RxList dashboardList = [].obs;
  RxList deviceList  = [].obs;
}
