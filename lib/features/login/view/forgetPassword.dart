import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thingsboard/features/login/controller/loginController.dart';
import 'package:thingsboard_pe_client/thingsboard_client.dart';
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController nameController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  bool visiblePassword = false;
  var tbClient = ThingsboardClient('https://dashboard.livair.io:443',onError: (e){
    Get.snackbar("Error", e.message!,colorText: Colors.white,backgroundColor: Colors.red);
  });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            height: height * 0.35,
            width: width<=800?width * 0.8:width*0.5,
            decoration: BoxDecoration(
                color: Color(0xff00695c),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListView(
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Request Password Reset",style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                        ),),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Username(email)*',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(()=>Container(
                                  height: 50,
                                  width: width<=800?width * 0.3:width*0.2,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffff5722), // This is what you need!
                                    ),
                                    child: loginController.isLoading.value?CircularProgressIndicator():const Text('Request Password Reset'),
                                    onPressed: () {
                                      nameController.clear();
                                     var res =   tbClient.sendResetPasswordLink(nameController.text);
                                      Get.snackbar("Success", "Reset link is send to your email",colorText: Colors.white,backgroundColor: Colors.green);
                                     },
                                  )),),
                              Container(
                                  height: 50,
                                  width: width<=800?width * 0.2:width*0.1,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff00c3b6), // This is what you need!
                                    ),
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      nameController.clear();
                                      Navigator.pop(context);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
