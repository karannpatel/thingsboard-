import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/view/device.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../constant.dart';
import '../controller/dashboardController.dart';

class DashboardEntityScreen extends StatefulWidget {
  DashboardEntityScreen({Key? key, required this.dashboardInfo}) : super(key: key);
  DashboardInfo dashboardInfo;

  @override
  State<DashboardEntityScreen> createState() => _DashboardEntityScreenState();
}

class _DashboardEntityScreenState extends State<DashboardEntityScreen> {
  DashboardController dashboardController = Get.put(DashboardController());
  ConstantController constantController = Get.put(ConstantController());
  void getData()async{
    DashboardInfo? res = await constantController.tbClient.getDashboardService().getDashboardInfo(widget.dashboardInfo!.id!.id!);
   PageData test = await constantController.tbClient.getDeviceProfileService().getDeviceProfileInfos(PageLink(100));
   dashboardController.deviceList.value = test.data;
    print(test);
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
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
                        var res = await constantController.tbClient.getDeviceService().getTenantDevice("Radon Devices");
                     print(res);
                        // SharedPreferences sharedPreference = await SharedPreferences.getInstance();
                        // Get.to(Device(token: sharedPreference.getString('token')!));
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Text(
                            dashboardController.deviceList[index].toString()),
                      ),
                    ),
                    itemCount: dashboardController.deviceList.length,
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
