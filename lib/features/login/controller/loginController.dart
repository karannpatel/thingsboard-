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

  void login(String email, String password) async {
    isLoading.value = true;
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();

    String url = 'https://dashboard.livair.io/api/auth/login';
    var body = {"username": email, "password": password};

    try {

      var res = await sl<Dio>().post(
        url,
        data: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        sharedPreferences.setString('token', res.data['token']);
        sharedPreferences.setString('refreshToken',  res.data['refreshToken']);

        Get.to(Dashboard());
      } else {
        if (res.data['status'] == 401) {
          Get.snackbar("Error", "Invalid Username and password",colorText: Colors.white,backgroundColor: Colors.red);
        }

        Get.snackbar("Error", "Something went wrong",colorText: Colors.white,backgroundColor: Colors.red);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong",colorText: Colors.white,backgroundColor: Colors.red);

    }
  }

  void resetPassword(String email)async{
    isLoading.value = true;
    String url = 'https://dashboard.livair.io/api/noauth/resetPasswordByEmail';
    var body = {"email": email,};

    try {
      print("0909--");
      var res = await sl<Dio>().post(
        url,
        data: jsonEncode(body),
      );
      print('0-0-0-0-0${res}');

      if (res.statusCode == 200) {
        Get.snackbar("Success", "Resent link has been sent",colorText: Colors.white,backgroundColor: Colors.green);
      }
      else {
        Get.snackbar("Error", "Something went wrong",colorText: Colors.white,backgroundColor: Colors.red);
      }
    }
    catch(e){
      Get.snackbar("Error", "Something went wrong",colorText: Colors.white,backgroundColor: Colors.red);
      isLoading.value = false;
    }
    isLoading.value = false;
  }
}
