
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chartSampleData.dart';


class CO2Graph extends StatefulWidget {
  List<ChartData> data;
  CO2Graph({required this.data});

  @override
  State<CO2Graph> createState() => _CO2GraphState();
}

class _CO2GraphState extends State<CO2Graph> {
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
                      format: 'point.x : point.y ppm',
                      textStyle: TextStyle(color: Colors.black))),
              primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 600,
                  interval: 200,
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
                    dataSource: widget.data,
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
