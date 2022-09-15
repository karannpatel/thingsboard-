import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:thingsboard/features/device/view/deviceDetail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../controller/dashboardController.dart';

class Device extends StatefulWidget {
  Device({Key? key, required this.token}) : super(key: key);
  String token;
  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  DashboardController dashboardController = Get.put(DashboardController());
  var channel;

  @override
  void initState() {
    channel = WebSocketChannel.connect(Uri.parse(
      'wss://dashboard.livair.io/api/ws/plugins/telemetry?token=' +
          widget.token,
    ));
    test();
    // TODO: implement initState
    super.initState();
  }



  void test() async {
    channel.sink.add('''{
  "attrSubCmds": [],
  "tsSubCmds": [],
  "historyCmds": [],
  "entityDataCmds": [
    {
      "query": {
        "entityFilter": {
          "type": "deviceType",
          "resolveMultiple": true,
          "deviceType": "Radon Devices",
          "deviceNameFilter": ""
        },
        "pageLink": {
          "pageSize": 1024,
          "page": 0,
          "sortOrder": {
            "key": {
              "type": "ENTITY_FIELD",
              "key": "createdTime"
            },
            "direction": "DESC"
          }
        },
        "entityFields": [
          {
            "type": "ENTITY_FIELD",
            "key": "name"
          },
          {
            "type": "ENTITY_FIELD",
            "key": "label"
          },
          {
            "type": "ENTITY_FIELD",
            "key": "additionalInfo"
          }
        ],
        "latestValues": [
          {
            "type": "ATTRIBUTE",
            "key": "active"
          }
        ]
      },
      "cmdId": 1
    },
    {
      "query": {
        "entityFilter": {
          "type": "singleEntity",
          "singleEntity": {
            "id": "4674ef00-249c-11ed-a05f-bda054e13867",
            "entityType": "DEVICE"
          }
        },
        "pageLink": {
          "pageSize": 1024,
          "page": 0,
          "sortOrder": {
            "key": {
              "type": "ENTITY_FIELD",
              "key": "createdTime"
            },
            "direction": "DESC"
          }
        },
        "entityFields": [
          {
            "type": "ENTITY_FIELD",
            "key": "name"
          },
          {
            "type": "ENTITY_FIELD",
            "key": "label"
          },
          {
            "type": "ENTITY_FIELD",
            "key": "additionalInfo"
          }
        ],
        "latestValues": [
          {
            "type": "ATTRIBUTE",
            "key": "active"
          },
          {
            "type": "TIME_SERIES",
            "key": "radon"
          },
          {
            "type": "TIME_SERIES",
            "key": "voc"
          },
          {
            "type": "TIME_SERIES",
            "key": "co2"
          },
          {
            "type": "TIME_SERIES",
            "key": "hum"
          },
          {
            "type": "TIME_SERIES",
            "key": "temp"
          },
          {
            "type": "TIME_SERIES",
            "key": "nox"
          },
          {
            "type": "TIME_SERIES",
            "key": "pm"
          }
        ]
      },
      "cmdId": 2
    }
  ],
  "entityDataUnsubscribeCmds": [],
  "alarmDataCmds": [],
  "alarmDataUnsubscribeCmds": [],
  "entityCountCmds": [],
  "entityCountUnsubscribeCmds": []
}}''');
    print("=========================+++++>");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Text(
          "Device",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        // Flexible(
        //   child: StreamBuilder(
        //     stream: channel.stream,
        //     builder: (context, snapshot) {
        //       //return Container();
        //       if (snapshot.hasData ||
        //           snapshot.connectionState == ConnectionState.active) {
        //         var res = snapshot.data;
        //         if (res != null) {
        //           var a = jsonDecode(snapshot.data.toString());
        //           var data = a;
        //           print(data);
        //           dashboardController.deviceList.add(data);
        //           dashboardController.deviceList.refresh();
        //           print('--=-=-=-=-=-=-=-=-=-');
        //           return Obx(() => ListView.builder(
        //             shrinkWrap: true,
        //                 itemBuilder: (context, index) => InkWell(
        //                   onTap: (){
        //                     Get.to(DeviceDetail());
        //                   },
        //                   child: Container(
        //                     margin: EdgeInsets.all(20),
        //                     child: Text(
        //                         dashboardController.deviceList[index]['data']
        //                                 ['data'][0]['latest']['ENTITY_FIELD']
        //                                 ['name']['value']
        //                             .toString()),
        //                   ),
        //                 ),
        //                 itemCount: dashboardController.deviceList.length,
        //               ));
        //         }
        //       }
        //       return Text("Np Data Found");
        //     },
        //   ),
        // )
      ]),
    );
  }
}
