
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../chartSampleData.dart';

class HumidityGraph extends StatefulWidget {
  List<ChartData> data;
  HumidityGraph({required this.data});

  @override
  State<HumidityGraph> createState() => _HumidityGraphState();
}

class _HumidityGraphState extends State<HumidityGraph> {
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
            plotAreaBorderColor: Colors.red,
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
                    format: 'point.x : point.y%',
                    textStyle: TextStyle(color: Colors.black))),
            // tooltipBehavior: TooltipBehavior(enable: true,header: "Humidity"),
            plotAreaBorderWidth: 0,
            borderWidth: 0,
            margin: EdgeInsets.only(
                left: 0, right: 0, top: 0, bottom: 5),
            primaryXAxis: DateTimeAxis(
                desiredIntervals: 10,
                interval: 10,
                maximum: DateTime.now().add(
                  const Duration(hours: 0, minutes: 5, seconds: 59),
                ),
                dateFormat: DateFormat.jm(),
                majorGridLines: const MajorGridLines(width: 0),
                minorGridLines: const MinorGridLines(width: 0)),

            primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
                interval: 20,
                majorGridLines: const MajorGridLines(width: 0),
                minorGridLines: const MinorGridLines(width: 0),
                numberFormat: NumberFormat.compact(),
                interactiveTooltip: InteractiveTooltip(
                  enable:
                  true, // when crosshair is used, this controls whether tooltip shows on y-axis
                )),
            series: <ChartSeries<ChartData, DateTime>>[
              AreaSeries<ChartData, DateTime>(
                  enableTooltip: true,
                  color: Colors.transparent,
                  dataSource: widget.data,
                  borderWidth: 1.5,
                  borderGradient:
                  const LinearGradient(colors: <Color>[
                    Colors.green,
                    Colors.red,
                  ], stops: <double>[
                    0.2,
                    0.9
                  ]),
                  xValueMapper: (ChartData sales, _) =>
                  sales.x,
                  yValueMapper: (ChartData sales, _) =>
                  sales.yValue)
            ],
          )
        ],
      ),
    );
  }
}
