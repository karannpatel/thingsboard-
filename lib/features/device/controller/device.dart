import 'package:get/get.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

import '../../../constant.dart';
import '../view/widgets/chartSampleData.dart';

class DeviceController extends GetxController {
  RxList<PageData> data = <PageData>[].obs;
  RxList temp = [].obs;
  RxList hum = [].obs;
  RxList<ChartData> tempData = <ChartData>[].obs;
  RxList<ChartData> humData = <ChartData>[].obs;
  RxList<ChartData> radonData = <ChartData>[].obs;
  RxList<ChartData> co2Data = <ChartData>[].obs;
  RxList<ChartData> noxData = <ChartData>[].obs;
  RxList<ChartData> vocData = <ChartData>[].obs;
  RxList<ChartData> pmData = <ChartData>[].obs;
  var subscription;
  void getData() async {
    ConstantController constantController = Get.put(ConstantController());
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
      data.add(dataUpdate.data!);
      data.refresh();
    });

    subscription.subscribe();
  }

  void getGraphData() async {
    ConstantController constantController = Get.put(ConstantController());
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
    var timeWindow = const Duration(seconds: 30).inMilliseconds;
    var tsCmd = TimeSeriesCmd(
        agg: Aggregation.NONE,
        limit: 100,
        fetchLatestPreviousPoint: true,
        keys: ['temp', 'hum', 'radon', 'voc', 'co2', 'pm', 'nox'],
        startTs: timeWindow,
        timeWindow: 630000);
    var hisCmd = EntityHistoryCmd(
        keys: ['temp', 'hum', 'radon', 'voc', 'co2', 'pm', 'nox'],
        startTs: DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
        endTs: DateTime.now()
            .add(const Duration(minutes: 10))
            .millisecondsSinceEpoch);
    // Create subscription command with entities query and timeseries subscription
    var cmd =
        EntityDataCmd(query: devicesQuery, tsCmd: tsCmd, historyCmd: hisCmd);

    // Create subscription with provided subscription command
    var telemetryService = constantController.tbClient.getTelemetryService();
    var subscription = TelemetrySubscriber(telemetryService, [cmd]);

    // Create listener to get data updates from WebSocket
    subscription.entityDataStream.listen((entityDataUpdate) {
      DataUpdate dataUpdate = entityDataUpdate;
      if (dataUpdate.data != null) {
        EntityData historyData = dataUpdate.data!.data[0];
        if (historyData.timeseries['radon']!.isNotEmpty) {
          for (var i in historyData.timeseries['radon']!) {
            radonData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
            radonData.refresh();
          }
        }
        if (historyData.timeseries['hum']!.isNotEmpty) {
          for (var i in historyData.timeseries['hum']!) {
            humData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
        if (historyData.timeseries['temp']!.isNotEmpty) {
          for (var i in historyData.timeseries['temp']!) {
            tempData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
        if (historyData.timeseries['voc']!.isNotEmpty) {
          for (var i in historyData.timeseries['voc']!) {
            vocData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
        if (historyData.timeseries['co2']!.isNotEmpty) {
          int j = 0;
          for (var i in historyData.timeseries['co2']!) {
            if (j == 0) {
              j = j + 1;
              continue;
            }
            co2Data.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
        if (historyData.timeseries['pm']!.isNotEmpty) {
          for (var i in historyData.timeseries['pm']!) {
            pmData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
        if (historyData.timeseries['nox']!.isNotEmpty) {
          for (var i in historyData.timeseries['nox']!) {
            noxData.add(ChartData(
                x: DateTime.fromMillisecondsSinceEpoch(i.ts),
                yValue: double.parse((i.value!))));
          }
        }
      }

      if (dataUpdate.update != null) {
        EntityData entityData = dataUpdate.update![0];
        if (entityData.timeseries['hum'] != null &&
            (entityData.timeseries['hum'] as List<TsValue>).isNotEmpty) {
          hum.add((entityData.timeseries['hum'] as List<TsValue>)[0].value);
          humData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['hum'] as List<TsValue>)[0].ts),
              yValue: double.parse(hum.last.toString())));
          humData.sort((a, b) => a.x.compareTo(b.x));
          //listSlot.add(FlSpot(i+1, double.parse(hum.last.toString())));
        }
        if (entityData.timeseries['temp'] != null &&
            (entityData.timeseries['temp'] as List<TsValue>).isNotEmpty) {
          temp.add((entityData.timeseries['temp'] as List<TsValue>)[0].value);
          tempData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['temp'] as List<TsValue>)[0].ts),
              yValue: double.parse(temp.last.toString())));
          tempData.sort((a, b) => a.x.compareTo(b.x));
        }
        if (entityData.timeseries['radon'] != null &&
            (entityData.timeseries['radon'] as List<TsValue>).isNotEmpty) {
          radonData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['radon'] as List<TsValue>)[0].ts),
              yValue: double.parse(
                  (entityData.timeseries['radon'] as List<TsValue>)[0]
                      .value!)));
          radonData.sort((a, b) => a.x.compareTo(b.x));
          radonData.refresh();
        }
        if (entityData.timeseries['co2'] != null &&
            (entityData.timeseries['co2'] as List<TsValue>).isNotEmpty) {
          co2Data.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['co2'] as List<TsValue>)[0].ts),
              yValue: double.parse(
                  (entityData.timeseries['co2'] as List<TsValue>)[0].value!)));
          co2Data.sort((a, b) => a.x.compareTo(b.x));
        }
        if (entityData.timeseries['voc'] != null &&
            (entityData.timeseries['voc'] as List<TsValue>).isNotEmpty) {
          vocData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['voc'] as List<TsValue>)[0].ts),
              yValue: double.parse(
                  (entityData.timeseries['voc'] as List<TsValue>)[0].value!)));
          vocData.sort((a, b) => a.x.compareTo(b.x));
        }
        if (entityData.timeseries['pm'] != null &&
            (entityData.timeseries['pm'] as List<TsValue>).isNotEmpty) {
          pmData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['pm'] as List<TsValue>)[0].ts),
              yValue: double.parse(
                  (entityData.timeseries['pm'] as List<TsValue>)[0].value!)));
          pmData.sort((a, b) => a.x.compareTo(b.x));
        }
        if (entityData.timeseries['nox'] != null &&
            (entityData.timeseries['nox'] as List<TsValue>).isNotEmpty) {
          noxData.add(ChartData(
              x: DateTime.fromMillisecondsSinceEpoch(
                  (entityData.timeseries['nox'] as List<TsValue>)[0].ts),
              yValue: double.parse(
                  (entityData.timeseries['nox'] as List<TsValue>)[0].value!)));
          noxData.sort((a, b) => a.x.compareTo(b.x));
        }
      }
    });

    // Perform subscribe (send subscription command via WebSocket API and listen for responses)
    subscription.subscribe();
  }
}
