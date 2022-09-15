import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/controller/dashboardController.dart';
import 'package:thingsboard/features/dashboard/view/dashboardEntity.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';

import '../../../constant.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController dashboardController = Get.put(DashboardController());
  ConstantController constantController = Get.put(ConstantController());
  void getData()async{
    PageData res = await constantController.tbClient.getDashboardService().getUserDashboards(PageLink(100,));
    dashboardController.dashboardList.value = res.data;
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            child: ListView(
                shrinkWrap: true,
                children: [

                  Text("Dashboard groups",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                 Obx(()=> ListView.builder(
                   shrinkWrap: true,
                   itemBuilder: (context,index){
                     DashboardInfo dashboardInfo =dashboardController.dashboardList[index];
                     return InkWell(
                       onTap: ()async{
                       Get.to(DashboardEntityScreen(dashboardInfo:dashboardInfo));
                       },
                       child: Container(
                         margin: EdgeInsets.all(20),
                         child: Text(dashboardInfo.title),
                       ),
                     );
                   },
                   itemCount: dashboardController.dashboardList.length,
                 )),

                ]),
          ),
        ),
      ),
    );
  }
}
