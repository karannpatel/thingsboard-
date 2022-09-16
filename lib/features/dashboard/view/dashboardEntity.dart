import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/view/device.dart';
import 'package:thingsboard/features/device/view/deviceDetail.dart';
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
  List<PageData> data =[];
  var subscription;
  void getData()async{
    print(constantController.tbClient.getJwtToken());
    var telemetryService = constantController.tbClient.getTelemetryService();
    subscription = TelemetrySubscriber(telemetryService,[EntityDataCmd(
        cmdId: 1,
        query: EntityDataQuery(pageLink: EntityDataPageLink(pageSize: 200),
            entityFilter: DeviceTypeFilter(deviceType: 'Radon Devices'),
            entityFields: [
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "name"),
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "label"),
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "additionalInfo"),
            ],
            latestValues: [
              EntityKey(type: EntityKeyType.ATTRIBUTE, key: "active")
            ]
        )),

      // EntityDataCmd(
      //   cmdId: 2,
      //     query:EntityDataQuery(
      //         pageLink: EntityDataPageLink(pageSize: 500), entityFilter: SingleEntityFilter(singleEntity:DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
      //       latestValues: [
      //         EntityKey(type: EntityKeyType.ATTRIBUTE, key: "active"),
      //         EntityKey(type: EntityKeyType.TIME_SERIES, key: "radon"),
      //         EntityKey(type: EntityKeyType.ATTRIBUTE, key: "voc"),
      //       ],
      //       entityFields: [
      //         EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "name"),
      //         EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "label"),
      //         EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "additionalInfo"),
      //       ]
      //     ),
      // )
    ]);
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
      setState((){
        data.add(dataUpdate.data!);
      });
    });

    subscription.subscribe();
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
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                EntityData pageData = data[index].data[0];
                Map<EntityKeyType,Map> dat = pageData.latest;
                TsValue device =   dat[EntityKeyType.ENTITY_FIELD]!['name'];
                return  InkWell(
                      onTap: () async
                {
                 Get.to(DeviceDetail());
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                     device.value!,
                  ),
                ));
  },
                itemCount: data.length,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
