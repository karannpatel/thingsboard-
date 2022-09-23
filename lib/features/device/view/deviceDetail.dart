// import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:thingsboard/features/device/controller/device.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

import '../../../constant.dart';
import '../../../injection_container.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({Key? key}) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  late TrackballBehavior _trackballBehavior;
  DeviceController deviceController = Get.put(DeviceController());
  ConstantController constantController = Get.put(ConstantController());
  List<PageData> data = [];
  List temp = [];
  List hum = [];
  List<ChartSampleData> tempData = <ChartSampleData>[];
  List<ChartSampleData> humData = <ChartSampleData>[];
  List<ChartSampleData> radonData = <ChartSampleData>[];
  List<ChartSampleData> co2Data = <ChartSampleData>[];
  List<ChartSampleData> noxData = <ChartSampleData>[];
  List<ChartSampleData> vocData = <ChartSampleData>[];
  List<ChartSampleData> pmData = <ChartSampleData>[];
  // List<FlSpot> listSlot =[
  //   FlSpot(1, 1),
  // ];

  WidgetType? widgetType = null;
  var subscription;
  void getData() async {
    var telemetryService = constantController.tbClient.getTelemetryService();
    subscription = TelemetrySubscriber(telemetryService, [
      EntityDataCmd(
        cmdId: 2,
        query: EntityDataQuery(
            pageLink: EntityDataPageLink(pageSize: 500),
            entityFilter: SingleEntityFilter(
                singleEntity: DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
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
              EntityKey(
                  type: EntityKeyType.ENTITY_FIELD, key: "additionalInfo"),
            ]),
      )
    ]);
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
      // setState(() {
      //   data.add(dataUpdate.data!);
      //   humData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['hum'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['hum'] as TsValue)
      //           .value
      //           .toString())));
      //   tempData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['temp'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['temp'] as TsValue)
      //           .value
      //           .toString())));
      //   radonData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['radon'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['radon'] as TsValue)
      //           .value
      //           .toString())));
      //   vocData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['voc'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['voc'] as TsValue)
      //           .value
      //           .toString())));
      //   co2Data.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['co2'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['co2'] as TsValue)
      //           .value
      //           .toString())));
      //   pmData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['pm'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['pm'] as TsValue)
      //           .value
      //           .toString())));
      //   noxData.add(ChartSampleData(
      //       x: DateTime.fromMillisecondsSinceEpoch(((data[0].data[0] as EntityData)
      //           .latest[EntityKeyType.TIME_SERIES]!['nox'] as TsValue)
      //           .ts),
      //       yValue: double.parse(((data[0].data[0] as EntityData)
      //               .latest[EntityKeyType.TIME_SERIES]!['nox'] as TsValue)
      //           .value
      //           .toString())));
      // });

       print( dataUpdate.data);
       print('-0-0-0890890i-s09d0-0osda-s-0s-a0s-a0s-a0');

    });
    var res = await constantController.tbClient
        .getWidgetService()
        .getWidgetType(false, "custom_widgets", 'single_value_average');
    setState(() {
      widgetType = res;
    });

    subscription.subscribe();
  }

  void getGraphData() async {
    // Prepare list of queried device fields

    // Create entity query with provided entity filter, queried fields and page link
    var devicesQuery = EntityDataQuery(
        entityFilter: SingleEntityFilter(
            singleEntity: DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
        pageLink: EntityDataPageLink(
            pageSize: 10,
            sortOrder: EntityDataSortOrder(
                key: EntityKey(
                    type: EntityKeyType.ENTITY_FIELD, key: 'createdTime'),
                direction: EntityDataSortOrderDirection.DESC)));
    var currentTime = DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
    var timeWindow = const Duration(seconds: 30).inMilliseconds;
    var tsCmd = TimeSeriesCmd(

        agg: Aggregation.NONE,
        limit: 100,
        fetchLatestPreviousPoint: true,
        keys: ['temp', 'hum', 'radon', 'voc', 'co2', 'pm', 'nox'],
        startTs: timeWindow,
        timeWindow: 630000);
    var hisCmd = EntityHistoryCmd(   keys: ['temp', 'hum', 'radon', 'voc', 'co2', 'pm', 'nox'], startTs: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch, endTs: DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch);
    // Create subscription command with entities query and timeseries subscription
    var cmd = EntityDataCmd(query: devicesQuery,tsCmd: tsCmd, historyCmd:hisCmd );

    // Create subscription with provided subscription command
    var telemetryService = constantController.tbClient.getTelemetryService();
    var subscription = TelemetrySubscriber(telemetryService, [cmd]);

    // Create listener to get data updates from WebSocket
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
    if(dataUpdate.data!=null){
      EntityData historyData = dataUpdate.data!.data[0];
      if(historyData.timeseries['radon']!.isNotEmpty){
        for(var i in historyData.timeseries['radon']!){
          radonData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['hum']!.isNotEmpty){
        for(var i in historyData.timeseries['hum']!){
          humData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['temp']!.isNotEmpty){
        for(var i in historyData.timeseries['temp']!){
          tempData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['voc']!.isNotEmpty){
        for(var i in historyData.timeseries['voc']!){
          vocData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['co2']!.isNotEmpty){
        int j=0;
        for(var i in historyData.timeseries['co2']!){
          if(j==0){
            j=j+1;
            continue;
          }
          co2Data.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['pm']!.isNotEmpty){
        for(var i in historyData.timeseries['pm']!){
          pmData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      if(historyData.timeseries['nox']!.isNotEmpty){
        for(var i in historyData.timeseries['nox']!){
          noxData.add(ChartSampleData(
              x: DateTime.fromMillisecondsSinceEpoch(i.ts),
              yValue: double.parse(
                  (i.value!))));
        }
      }
      print(historyData.timeseries['radon']);
    }
      print('0-0-0-0-0-0-0-0-0-0-');
      print(dataUpdate.update);
      setState(() {
        if (dataUpdate.update != null) {
          EntityData entityData = dataUpdate.update![0];
          print('8787878787878787');
          if (entityData.timeseries['hum'] != null&& (entityData.timeseries['hum'] as List<TsValue>).isNotEmpty) {
            hum.add((entityData.timeseries['hum'] as List<TsValue>)[0].value);
            humData.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['hum'] as List<TsValue>)[0].ts), yValue: double.parse(hum.last.toString())));
            humData.sort((a,b)=>a.x.compareTo(b.x));
            //listSlot.add(FlSpot(i+1, double.parse(hum.last.toString())));
          }
          if (entityData.timeseries['temp'] != null && (entityData.timeseries['temp'] as List<TsValue>).isNotEmpty) {
            temp.add((entityData.timeseries['temp'] as List<TsValue>)[0].value);
            tempData.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['temp'] as List<TsValue>)[0].ts), yValue: double.parse(temp.last.toString())));
            tempData.sort((a,b)=>a.x.compareTo(b.x));
          }
          if (entityData.timeseries['radon'] != null && (entityData.timeseries['radon'] as List<TsValue>).isNotEmpty) {
            radonData.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['radon'] as List<TsValue>)[0].ts),
                yValue: double.parse(
                    (entityData.timeseries['radon'] as List<TsValue>)[0]
                        .value!)));
            radonData.sort((a,b)=>a.x.compareTo(b.x));
          }
          if (entityData.timeseries['co2'] != null && (entityData.timeseries['co2'] as List<TsValue>).isNotEmpty) {
            co2Data.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['co2'] as List<TsValue>)[0].ts),
                yValue: double.parse(
                    (entityData.timeseries['co2'] as List<TsValue>)[0]
                        .value!)));
            co2Data.sort((a,b)=>a.x.compareTo(b.x));
          }
          if (entityData.timeseries['voc'] != null && (entityData.timeseries['voc'] as List<TsValue>).isNotEmpty) {
            vocData.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['voc'] as List<TsValue>)[0].ts),
                yValue: double.parse(
                    (entityData.timeseries['voc'] as List<TsValue>)[0]
                        .value!)));
            vocData.sort((a,b)=>a.x.compareTo(b.x));
          }
          if (entityData.timeseries['pm'] != null && (entityData.timeseries['pm'] as List<TsValue>).isNotEmpty) {
            pmData.add(ChartSampleData(
                x: DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['pm'] as List<TsValue>)[0].ts),
                yValue: double.parse(
                    (entityData.timeseries['pm'] as List<TsValue>)[0].value!)));
            pmData.sort((a,b)=>a.x.compareTo(b.x));
          }
          if (entityData.timeseries['nox'] != null && (entityData.timeseries['nox'] as List<TsValue>).isNotEmpty) {
            noxData.add(ChartSampleData(
                x:DateTime.fromMillisecondsSinceEpoch((entityData.timeseries['nox'] as List<TsValue>)[0].ts),
                yValue: double.parse(
                    (entityData.timeseries['nox'] as List<TsValue>)[0]
                        .value!)));
            noxData.sort((a,b)=>a.x.compareTo(b.x));
          }
        }
      });

    });

    // Perform subscribe (send subscription command via WebSocket API and listen for responses)
    subscription.subscribe();
  }


  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    getData();
    getGraphData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(56.0),
          child: Column(
            children: [
              const TopBar(),
              const SizedBox(
                height: 35,
              ),
              data.isNotEmpty
                  ? Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      height: 80,
                      width: width + 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffECEFF1))),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff0ACF84),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(4),
                                      )),
                                  child: const Center(
                                    child: Text(
                                      "Good",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                const Text(
                                  "SCORE   ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                const Text(
                                  "80  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  "/  100",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: const Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "RADON   ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  ((data[0].data[0] as EntityData).latest[
                                                  EntityKeyType
                                                      .TIME_SERIES]!['radon']
                                              as TsValue)
                                          .value
                                          .toString() +
                                      "  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " Bq/m3",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xffFD4C56),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "CO2   ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  ((data[0].data[0] as EntityData).latest[
                                                  EntityKeyType
                                                      .TIME_SERIES]!['co2']
                                              as TsValue)
                                          .value
                                          .toString() +
                                      "  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " / 100",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: const Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "NO2   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  ((data[0].data[0] as EntityData).latest[
                                                  EntityKeyType
                                                      .TIME_SERIES]!['nox']
                                              as TsValue)
                                          .value
                                          .toString() +
                                      "80  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " /100",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: const Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "VOC   ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  ((data[0].data[0] as EntityData).latest[
                                                  EntityKeyType
                                                      .TIME_SERIES]!['voc']
                                              as TsValue)
                                          .value
                                          .toString() +
                                      "  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " /100",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "DUST   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  "80  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  " ug/m3",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "HUMDITY   ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  (double.parse(((data[0].data[0] as EntityData)
                                                          .latest[
                                                      EntityKeyType
                                                          .TIME_SERIES]!['hum']
                                                  as TsValue)
                                              .value
                                              .toString()))
                                          .toPrecision(2)
                                          .toString() +
                                      "  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " %",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: const Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "TEMPERATURE   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  (double.parse(((data[0].data[0] as EntityData)
                                                          .latest[
                                                      EntityKeyType
                                                          .TIME_SERIES]!['temp']
                                                  as TsValue)
                                              .value
                                              .toString()))
                                          .toPrecision(2)
                                          .toString() +
                                      "  ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                const Text(
                                  " C",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "PRESSURE   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  "30  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  " C",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "LIGHT   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  "98  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  " lx",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            color: const Color(0xffECEFF1).withOpacity(0.4),
                            height: 40,
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Color(0xff0ACF84),
                                  radius: 7,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "NOISE   ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff78909C)),
                                ),
                                Text(
                                  "30  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  " db",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 23,
              ),
              const ButtonList(),
              const SizedBox(
                height: 23,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/humidity.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "Humidity - Last 12 hours",
                          style:
                              TextStyle(color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(

                        plotAreaBorderColor: Colors.transparent,

                        primaryYAxis: CategoryAxis(

                            minimum: 0,
                            maximum: 100,
                            interval: 20,
                            axisLabelFormatter: (cv)=>ChartAxisLabel(cv.text,TextStyle(color: Colors.red)),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              enableTooltip: true,
                              color: Colors.transparent,
                              dataSource: humData,
                              borderWidth: 1.5,
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/Radon.png'),
                        const Text(
                          "Randon - Last 12 hours",
                          style: TextStyle(
                              color: const Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(
                            minimum: 0,
                            maximum: 1000,
                            interval: 200,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            labelFormat: '{value}°C',
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: radonData,
                              color: Colors.transparent,
                              borderWidth: 1.5,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/temperature.png'),
                        const Text(
                          "TEMPERATURE - Last 12 hours",
                          style:
                              TextStyle(color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                      SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(

                            minimum: -20,
                            maximum: 100,
                            interval: 20,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: tempData,
                              color: Colors.transparent,
                              borderWidth: 1.5,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/voc.png'),
                        const Text(
                          "VOC - Last 12 hours",
                          style:
                              TextStyle(color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(
                            minimum: 0,
                            maximum: 600,
                            interval: 200,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            labelFormat: '{value}°C',
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              enableTooltip: true,
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: vocData,
                              borderWidth: 1.5,
                              color: Colors.transparent,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/co2.png'),
                        const Text(
                          "CO2 - Last 12 hours",
                          style:
                              TextStyle(color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(
                            minimum: 0,
                            maximum: 600,
                            interval: 200,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              color: Colors.transparent,
                              borderWidth: 1.5,
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: co2Data,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/pressure.png'),
                        const Text(
                          "PM - Last 12 hours",
                          style: const TextStyle(
                              color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 20,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              color: Colors.transparent,
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: pmData,
                              borderWidth: 1.5,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEFF1))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset('/images/nox.png'),
                        const Text(
                          "NOx - Last 12 hours",
                          style:
                              TextStyle(color: Color(0xff78909C), fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SfCartesianChart(
                        plotAreaBorderColor: Colors.transparent,
                        primaryYAxis: CategoryAxis(
                            minimum: 0,
                            maximum: 1,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 10,
                            interval: 10,
                            maximum: DateTime.now().add(
                              const Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              color: Colors.transparent,
                              borderGradient:
                                  const LinearGradient(colors: <Color>[
                                Colors.green,
                                Colors.red,
                              ], stops: <double>[
                                0.2,
                                0.9
                              ]),
                              dataSource: noxData,
                              borderWidth: 1.5,
                              xValueMapper: (ChartSampleData sales, _) =>
                                  sales.x,
                              yValueMapper: (ChartSampleData sales, _) =>
                                  sales.yValue)
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartSampleData {
  final DateTime x;
  final double yValue;

  ChartSampleData({required this.x, required this.yValue});
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: width,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
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
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: width,
          child: IntrinsicWidth(
            child: Wrap(
              spacing: 20,
              alignment: WrapAlignment.spaceBetween,
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
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "455556565599A5",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Sensor serial number",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "xxxxxxxxxxx-xxxxxxxxxxx",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Last synced",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
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
                const SizedBox(
                  height: 20,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Location",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "MTZ Munich",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Building type",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Office",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Floor",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "1 Floor       ",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Usuage hours",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Monday till Friday",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Device added",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Aug 20,2021",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Dashboard access",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Aug, 20,2024",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                IntrinsicWidth(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Sensor calibration",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "view certificate",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Next calibration",
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Aug 20,2022",
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class ButtonList extends StatelessWidget {
  const ButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          IntrinsicWidth(
            child: Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 12 Hours"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 24 Hours"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Week"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Month"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 6 Months"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Year"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Custom"),
                ),
                const SizedBox(
                  width: 10,
                ),
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffECEFF1))),
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check_box_outline_blank,
                          size: 25,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Consider usage hours"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          IntrinsicWidth(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/collapse_charts.png'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text("Collapse charts"),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/download.png'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text("Exports to CSV"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



