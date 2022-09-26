
import 'package:flutter/material.dart';

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
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 12 Hours"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 24 Hours"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Week"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Month"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last 6 Months"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffECEFF1))),
                  height: 40,
                  child: const Text("Last Year"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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