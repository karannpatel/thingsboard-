import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thingsboard/features/device/controller/device.dart';
import 'package:thingsboard/features/device/view/widgets/buttonList.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/co2.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/humidity.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/nox.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/pm.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/radon.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/temp.dart';
import 'package:thingsboard/features/device/view/widgets/graphs/voc.dart';
import 'package:thingsboard/features/device/view/widgets/infoBar.dart';
import 'package:thingsboard/features/device/view/widgets/topBar.dart';
import '../../../constant.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({Key? key}) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  DeviceController deviceController = Get.put(DeviceController());
  ConstantController constantController = Get.put(ConstantController());

  @override
  void initState() {
    deviceController.getData();
    deviceController.getGraphData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(56.0),
          child: Column(children: [
            const TopBar(),
            const SizedBox(
              height: 35,
            ),
            const InfoBar(),
            const SizedBox(
              height: 23,
            ),
            const ButtonList(),
            const SizedBox(
              height: 23,
            ),
            Obx(() => HumidityGraph(data: deviceController.humData.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => RadonGraph(data: deviceController.radonData.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => TempGraph(data: deviceController.tempData.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => VocGraph(data: deviceController.vocData.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => CO2Graph(data: deviceController.co2Data.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => PmGraph(data: deviceController.pmData.toList())),
            const SizedBox(
              height: 16,
            ),
            Obx(() => NoxGraph(data: deviceController.noxData.toList()))
          ])),
    ));
  }
}
