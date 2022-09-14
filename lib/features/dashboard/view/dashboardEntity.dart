import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/view/device.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../controller/dashboardController.dart';

class DashboardEntity extends StatefulWidget {
  DashboardEntity({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<DashboardEntity> createState() => _DashboardEntityState();
}

class _DashboardEntityState extends State<DashboardEntity> {
  DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    dashboardController.getEntityGroup(widget.id, '10', '0');
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    dashboardController.entityGroupList.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            child: Column(children: [
              Text(
                "Dashboard Entity groups",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async{
                        SharedPreferences sharedPreference = await SharedPreferences.getInstance();
                        Get.to(Device(token: sharedPreference.getString('token')!));
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Text(
                            dashboardController.entityGroupList[index].name),
                      ),
                    ),
                    itemCount: dashboardController.entityGroupList.length,
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
