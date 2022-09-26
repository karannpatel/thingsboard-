
import 'package:flutter/material.dart';

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