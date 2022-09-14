import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/features/dashboard/controller/dashboardController.dart';
import 'package:thingsboard/features/dashboard/view/dashboardEntity.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardController dashboardController = Get.put(DashboardController());
  @override
  void initState() {
    dashboardController.getDashboardGroup();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    dashboardController.dashboardGroupList.clear();
    // TODO: implement dispose
    super.dispose();
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
                   itemBuilder: (context,index)=>InkWell(
                     onTap: ()async{

                       Get.to(DashboardEntity(id: dashboardController.dashboardGroupList[index].id['id']));
                     },
                     child: Container(
                     margin: EdgeInsets.all(20),
                     child: Text(dashboardController.dashboardGroupList[index].name),
                 ),
                   ),
                   itemCount: dashboardController.dashboardGroupList.length,
                 )),

                ]),
          ),
        ),
      ),
    );
  }
}
