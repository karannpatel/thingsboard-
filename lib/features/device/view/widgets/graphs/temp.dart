
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chartSampleData.dart';

class TempGraph extends StatefulWidget {
  List<ChartData> data;
  TempGraph({required this.data});

  @override
  State<TempGraph> createState() => _TempGraphState();
}

class _TempGraphState extends State<TempGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  markerSettings: const TrackballMarkerSettings(
                      markerVisibility:
                      TrackballVisibilityMode.visible,
                      shape: DataMarkerType.circle,
                      width: 13,
                      height: 13,
                      borderColor: Colors.black,
                      color: Color(0xffFC9626)),
                  tooltipSettings: InteractiveTooltip(
                      color: Colors.white,
                      borderWidth: 1.5,
                      borderColor: Color(0xffCFD8DC),
                      // Formatting trackball tooltip text
                      format: 'point.x : point.y °C',
                      textStyle: TextStyle(color: Colors.black))),
              primaryYAxis: NumericAxis(
                  minimum: -20,
                  maximum: 100,
                  interval: 20,
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0)),
              primaryXAxis: DateTimeAxis(
                  desiredIntervals: 10,
                  interval: 10,
                  maximum: DateTime.now().add(
                    const Duration(
                        hours: 0, minutes: 5, seconds: 59),
                  ),
                  dateFormat: DateFormat.jm(),
                  majorGridLines: const MajorGridLines(width: 0),
                  minorGridLines: const MinorGridLines(width: 0)),
              series: <ChartSeries<ChartData, DateTime>>[
                AreaSeries<ChartData, DateTime>(
                    enableTooltip: true,
                    borderGradient:
                    const LinearGradient(colors: <Color>[
                      Colors.green,
                      Colors.red,
                    ], stops: <double>[
                      0.2,
                      0.9
                    ]),
                    dataSource: widget.data,
                    color: Colors.transparent,
                    borderWidth: 1.5,
                    xValueMapper: (ChartData sales, _) =>
                    sales.x,
                    yValueMapper: (ChartData sales, _) =>
                    sales.yValue)
              ]),
        ],
      ),
    );
  }
}
