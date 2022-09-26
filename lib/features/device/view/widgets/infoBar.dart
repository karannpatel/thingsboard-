import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

import '../../controller/device.dart';

class InfoBar extends StatefulWidget {
  const InfoBar({Key? key}) : super(key: key);

  @override
  State<InfoBar> createState() => _InfoBarState();
}

class _InfoBarState extends State<InfoBar> {
  DeviceController deviceController = Get.put(DeviceController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(()=>deviceController.data.isNotEmpty
        ? Container(
      padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 16),
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
                  ((deviceController.data[0].data[0] as EntityData).latest[
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
                  ((deviceController.data[0].data[0] as EntityData).latest[
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
                  ((deviceController.data[0].data[0] as EntityData).latest[
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
                  ((deviceController.data[0].data[0] as EntityData).latest[
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
                  (double.parse(((deviceController.data[0].data[0] as EntityData)
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
                  (double.parse(((deviceController.data[0].data[0] as EntityData)
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
        : const SizedBox(),);
  }
}
