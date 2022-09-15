import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/view/dashboard.dart';
import '../../../injection_container.dart';
import '../../../main.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

}
