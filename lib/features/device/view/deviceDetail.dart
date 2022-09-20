import 'package:fl_chart/fl_chart.dart';
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
  List temp =[];
  List hum =[];
  List<FlSpot> listSlot =[
    FlSpot(1, 1),
    FlSpot(3, 1.5),
    FlSpot(5, 1.4),
    FlSpot(7, 3.4),
    FlSpot(10, 2),
    FlSpot(12, 2.2),
    FlSpot(13, 1.8),
  ];
  int i=13;
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
  void getGraphData()async{
    // Prepare list of queried device fields
    var deviceFields = <EntityKey>[
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'name'),
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'type'),
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'createdTime')
    ];

    // Prepare list of queried device timeseries
    var deviceTelemetry = <EntityKey>[
      EntityKey(type: EntityKeyType.TIME_SERIES, key: 'temperature'),
      EntityKey(type: EntityKeyType.TIME_SERIES, key: 'humidity')
    ];

    // Create entity query with provided entity filter, queried fields and page link
    var devicesQuery = EntityDataQuery(
        entityFilter: SingleEntityFilter(singleEntity:DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
        entityFields: deviceFields,
        latestValues: deviceTelemetry,
        pageLink: EntityDataPageLink(
            pageSize: 10,
            sortOrder: EntityDataSortOrder(
                key: EntityKey(
                    type: EntityKeyType.ENTITY_FIELD, key: 'createdTime'),
                direction: EntityDataSortOrderDirection.DESC)));

    // Create timeseries subscription command to get data for 'temperature' and 'humidity' keys for last hour with realtime updates
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var timeWindow = Duration(hours: 1).inMilliseconds;

    var tsCmd = TimeSeriesCmd(
        agg: Aggregation.AVG,
        limit: 21,
        interval:30000,
        keys: ['temp', 'hum'],
        startTs: 1663674780000,
        timeWindow: 630000);

    // Create subscription command with entities query and timeseries subscription
    var cmd = EntityDataCmd(query: devicesQuery, tsCmd: tsCmd);

    // Create subscription with provided subscription command
    var telemetryService = constantController.tbClient.getTelemetryService();
    var subscription = TelemetrySubscriber(telemetryService, [cmd]);

    // Create listener to get data updates from WebSocket
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
      setState((){
        if(dataUpdate.update!=null) {
          EntityData entityData = dataUpdate.update![0];

          print(entityData);
          if(entityData.timeseries['hum'] != null){
          hum.add((entityData.timeseries['hum'] as List<TsValue>)[0].value);
          listSlot.add(FlSpot(i+1, double.parse(hum.last.toString())));
          i=i+1;
          }
          if(entityData.timeseries['temp'] != null)
          temp.add((entityData.timeseries['temp'] as List<TsValue>)[0].value);
          }
        
      });
      print('Received entity data update: $entityDataUpdate');
      print('/*/*/*/*/*/*/*/*/*/*/*/*/');
    });

    // Perform subscribe (send subscription command via WebSocket API and listen for responses)
    subscription.subscribe();
  }
  @override
  void initState() {
    getData();
    getGraphData();
    // TODO: implement initState
    super.initState();
  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '1m';
        break;
      case 20:
        text = '2m';
        break;
      case 30:
        text = '3m';
        break;
      case 40:
        text = '5m';
        break;
      case 50:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
                        children: const [
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
            data.isNotEmpty?Center(
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
            ):SizedBox(),

            Text("Temp   "+(temp.toString() )),//:Container(),//as >).latest[EntityKeyType.ATTRIBUTE].toString())
            Text("Humidity   "+(hum.toString() )),//:Container(),//as >).latest[EntityKeyType.ATTRIBUTE].toString())


       SizedBox(
         width: 700,
         height: 500,
         child:  LineChart(LineChartData(
           lineTouchData: LineTouchData(
             handleBuiltInTouches: true,
             touchTooltipData: LineTouchTooltipData(
               tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
             ),
           ),
           gridData: FlGridData(show: false),
           titlesData: FlTitlesData(
             bottomTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 reservedSize: 32,
                 interval: 1,
               ),
             ),
             rightTitles: AxisTitles(
               sideTitles: SideTitles(showTitles: false),
             ),
             topTitles: AxisTitles(
               sideTitles: SideTitles(showTitles: false),
             ),
             leftTitles: AxisTitles(
               sideTitles: SideTitles(
                 showTitles: true,
                 interval: 20,
                 reservedSize: 120,
               ),
             ),
           ),
           borderData: FlBorderData(
             show: true,
             border: const Border(
               bottom: BorderSide(color: Color(0xff4e4965), width: 4),
               left: BorderSide(color: Colors.transparent),
               right: BorderSide(color: Colors.transparent),
               top: BorderSide(color: Colors.transparent),
             ),
           ),
           lineBarsData: [
             LineChartBarData(
               isCurved: true,
               color: const Color(0xff4af699),
               barWidth: 8,
               isStrokeCapRound: true,
               dotData: FlDotData(show: false),
               belowBarData: BarAreaData(show: false),
               spots: listSlot
             ),
           ],
           minX: 0,
           maxX: 14,
           maxY: 140,
           minY: 0,
         ),
         swapAnimationDuration: const Duration(milliseconds: 250),
       ),
       )

          ],
        ),
      ),
    );
  }
}