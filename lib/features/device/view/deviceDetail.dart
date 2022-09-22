// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
      setState(() {
        data.add(dataUpdate.data!);
        humData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['hum'] as TsValue)
                .value
                .toString())));
        tempData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['temp'] as TsValue)
                .value
                .toString())));
        radonData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['radon'] as TsValue)
                .value
                .toString())));
        vocData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['voc'] as TsValue)
                .value
                .toString())));
        co2Data.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['co2'] as TsValue)
                .value
                .toString())));
        pmData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['pm'] as TsValue)
                .value
                .toString())));
        noxData.add(ChartSampleData(
            x: DateTime.now(),
            yValue: double.parse(((data[0].data[0] as EntityData)
                    .latest[EntityKeyType.TIME_SERIES]!['nox'] as TsValue)
                .value
                .toString())));
      });
      print(data);
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
        entityFilter: SingleEntityFilter(
            singleEntity: DeviceId("e2dd9ae0-342d-11ed-a05f-bda054e13867")),
        entityFields: deviceFields,
        latestValues: deviceTelemetry,
        pageLink: EntityDataPageLink(
            pageSize: 10,
            sortOrder: EntityDataSortOrder(
                key: EntityKey(
                    type: EntityKeyType.ENTITY_FIELD, key: 'createdTime'),
                direction: EntityDataSortOrderDirection.DESC)));

    var tsCmd = TimeSeriesCmd(
        agg: Aggregation.AVG,
        limit: 21,
        interval: 30000,
        keys: ['temp', 'hum', 'radon', 'voc', 'co2', 'pm', 'nox'],
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
          if (dataUpdate.update != null) {
            EntityData entityData = dataUpdate.update![0];

            print(entityData);
            if (entityData.timeseries['hum'] != null) {
              hum.add((entityData.timeseries['hum'] as List<TsValue>)[0].value);
              humData.add(ChartSampleData(
                  x: DateTime.now(), yValue: double.parse(hum.last.toString())));
              //listSlot.add(FlSpot(i+1, double.parse(hum.last.toString())));
            }
            if (entityData.timeseries['temp'] != null) {
              temp.add((entityData.timeseries['temp'] as List<TsValue>)[0].value);
              tempData.add(ChartSampleData(
                  x: DateTime.now(), yValue: double.parse(temp.last.toString())));
            }
            if (entityData.timeseries['radon'] != null) {
              radonData.add(ChartSampleData(
                  x: DateTime.now(),
                  yValue: double.parse(
                      (entityData.timeseries['radon'] as List<TsValue>)[0]
                          .value!)));
            }
            if (entityData.timeseries['co2'] != null) {
              co2Data.add(ChartSampleData(
                  x: DateTime.now(),
                  yValue: double.parse(
                      (entityData.timeseries['co2'] as List<TsValue>)[0]
                          .value!)));
            }
            if (entityData.timeseries['voc'] != null) {
              vocData.add(ChartSampleData(
                  x: DateTime.now(),
                  yValue: double.parse(
                      (entityData.timeseries['voc'] as List<TsValue>)[0]
                          .value!)));
            }
            if (entityData.timeseries['pm'] != null) {
              pmData.add(ChartSampleData(
                  x: DateTime.now(),
                  yValue: double.parse(
                      (entityData.timeseries['pm'] as List<TsValue>)[0].value!)));
            }
            if (entityData.timeseries['nox'] != null) {
              noxData.add(ChartSampleData(
                  x: DateTime.now(),
                  yValue: double.parse(
                      (entityData.timeseries['nox'] as List<TsValue>)[0]
                          .value!)));
            }
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(56.0),
          child: Column(
            children: [
              TopBar(),
              SizedBox(
                height: 35,
              ),
              data.isNotEmpty?Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                height: 80,
                width: width+40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffECEFF1))
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Color(0xff0ACF84),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                )),
                            child: Center(
                              child: Text(
                                "Good",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "SCORE   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            "80  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            "/  100",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff0ACF84),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "RADON   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            ((data[0].data[0] as EntityData).latest[
                              EntityKeyType.TIME_SERIES]!['radon']
                              as TsValue)
                              .value
                              .toString()+"  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " Bq/m3",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xffFD4C56),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "CO2   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            ((data[0].data[0] as EntityData).latest[
                            EntityKeyType.TIME_SERIES]!['co2']
                            as TsValue)
                                .value
                                .toString()+"  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " / 100",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff0ACF84),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "NO2   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            ((data[0].data[0] as EntityData).latest[
                            EntityKeyType.TIME_SERIES]!['nox']
                            as TsValue)
                                .value
                                .toString()+"80  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " /100",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff0ACF84),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "VOC   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            ((data[0].data[0] as EntityData).latest[
                            EntityKeyType.TIME_SERIES]!['voc']
                            as TsValue)
                                .value
                                .toString()+"  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " /100",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
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
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " ug/m3",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff0ACF84),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "HUMDITY   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            (double.parse(((data[0].data[0] as EntityData).latest[
                            EntityKeyType.TIME_SERIES]!['hum']
                            as TsValue)
                                .value
                                .toString())).toPrecision(2).toString()+"  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " %",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff0ACF84),
                            radius: 7,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "TEMPERATURE   ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff78909C)),
                          ),
                          Text(
                            (double.parse(((data[0].data[0] as EntityData).latest[
                            EntityKeyType.TIME_SERIES]!['temp']
                            as TsValue)
                                .value
                                .toString())).toPrecision(2).toString()+"  ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " C",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
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
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " C",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
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
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " lx",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      color: Color(0xffECEFF1).withOpacity(0.4),
                      height: 40,
                      child: Row(
                        children: [
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
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            " db",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ):SizedBox(),
              SizedBox(
                height: 23,
              ),
              SizedBox(
                width: width,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                      IntrinsicWidth(
                        child: Wrap(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last 12 Hours"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last 24 Hours"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last Week"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last Month"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last 6 Months"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last Year"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Text("Last Custom"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffECEFF1))
                              ),
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_box_outline_blank,size: 25,),
                                  SizedBox(width: 12,),
                                  Text("Consider usage hours"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                    ),
                      ),
                    IntrinsicWidth(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('images/collapse_charts.png'),
                                SizedBox(width: 12,),
                                Text("Collapse charts"),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffECEFF1))
                            ),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('images/download.png'),
                                SizedBox(width: 12,),
                                Text("Exports to CSV"),
                              ],
                            ),
                          ),
                        ],

                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
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
                        SizedBox(width: 8,),
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
                            minimum: 0, maximum: 100, interval: 20,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              dataSource: humData,
                              color: Colors.transparent,
                              borderWidth: 4,
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
                            minimum: 0, maximum: 1000, interval: 200,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
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
                              borderWidth: 4,
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
                            minimum: -20, maximum: 100, interval: 20,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
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
                              borderWidth: 4,
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
                            minimum: 0, maximum: 600, interval: 200,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
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
                              dataSource: vocData,
                              borderWidth: 4,
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
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
                            ),
                            dateFormat: DateFormat.jm(),
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        series: <ChartSeries<ChartSampleData, DateTime>>[
                          AreaSeries<ChartSampleData, DateTime>(
                              color: Colors.transparent,
                              borderWidth: 4,
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
                            minimum: 0, maximum: 100, interval: 20,
                            majorGridLines: const MajorGridLines(width: 0),
                            minorGridLines: const MinorGridLines(width: 0)),
                        primaryXAxis: DateTimeAxis(
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
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
                              borderWidth: 4,
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
                            desiredIntervals: 1,
                            interval: 1,
                            maximum: DateTime.now().add(
                              Duration(hours: 0, minutes: 5, seconds: 59),
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
                              borderWidth: 4,
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
        SizedBox(
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
                      SizedBox(
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
                      SizedBox(
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
