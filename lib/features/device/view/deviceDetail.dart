import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thingsboard/features/device/controller/device.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({Key? key}) : super(key: key);

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  DeviceController deviceController = Get.put(DeviceController());
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
            )
          ],
        ),
      ),
    );
  }
}
