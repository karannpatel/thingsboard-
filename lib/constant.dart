import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

class ConstantController extends GetxController{
  var tbClient = ThingsboardClient('https://dashboard.livair.io:443',onError: (e){
    Get.snackbar("Error", e.message!,colorText: Colors.white,backgroundColor: Colors.red);
  });
}