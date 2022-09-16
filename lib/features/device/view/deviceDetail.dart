import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thingsboard/features/device/controller/device.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

import '../../../constant.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({Key? key}) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  DeviceController deviceController = Get.put(DeviceController());
  ConstantController constantController = Get.put(ConstantController());
  List<PageData> data =[];
  WidgetType? widgetType=null;
  var subscription;
  void getData()async{

   print('=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=');
   var telemetryService = constantController.tbClient.getTelemetryService();
    subscription = TelemetrySubscriber(telemetryService,[

      EntityDataCmd(
        cmdId: 2,
        query:EntityDataQuery(
            pageLink: EntityDataPageLink(pageSize: 500), entityFilter: SingleEntityFilter(singleEntity:DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
            latestValues: [
              EntityKey(type: EntityKeyType.ATTRIBUTE, key: "active"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "radon"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "voc"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "co2"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "hum"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "temp"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "nox"),
              EntityKey(type: EntityKeyType.TIME_SERIES, key: "pm"),
            ],
            entityFields: [
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "name"),
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "label"),
              EntityKey(type: EntityKeyType.ENTITY_FIELD, key: "additionalInfo"),
            ]
        ),
      )
    ]);
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
      setState((){
        data.add(dataUpdate.data!);

      });
      print(data);
    });
    var res = await constantController.tbClient.getWidgetService().getWidgetType(false,"custom_widgets",'single_value_average');
    setState((){
      widgetType =res;
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Max's Office Device",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                      icon: const Icon(
                          // <-- Icon
                          Icons.edit,
                          size: 24.0,
                          color: Colors.black),
                      label: const Text(
                        'Rename',
                        style: TextStyle(color: Colors.black),
                      ), // <-- Text
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                      icon: const Icon(
                          // <-- Icon
                          Icons.directions,
                          size: 24.0,
                          color: Colors.black),
                      label: const Text(
                        'Change location',
                        style: TextStyle(color: Colors.black),
                      ), // <-- Text
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                      icon: const Icon(
                          // <-- Icon
                          Icons.delete,
                          size: 24.0,
                          color: Colors.black),
                      label: const Text(
                        'Delete',
                        style: const TextStyle(color: Colors.black),
                      ), // <-- Text
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MAC address",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "455556565599A5",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sensor serial number",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "xxxxxxxxxxx-xxxxxxxxxxx",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last synced",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "8 minutes ago",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MAC address",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "455556565599A5",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sensor serial number",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "xxxxxxxxxxx-xxxxxxxxxxx",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last synced",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "8 minutes ago",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MAC address",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "455556565599A5",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sensor serial number",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "xxxxxxxxxxx-xxxxxxxxxxx",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last synced",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "8 minutes ago",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MAC address",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "455556565599A5",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sensor serial number",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "xxxxxxxxxxx-xxxxxxxxxxx",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last synced",
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "8 minutes ago",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Text("Randon   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['radon'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("Humidity   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['hum'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("Temp   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['temp'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("NoX   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['nox'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("CO2   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['co2'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("PM   "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['pm'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    Text("VOC  "+((data[0].data[0] as EntityData ).latest[EntityKeyType.TIME_SERIES]!['voc'] as TsValue ).value.toString()),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
                    //widgetType!=null?Text(widgetType!.descriptor['templateCss']):SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
