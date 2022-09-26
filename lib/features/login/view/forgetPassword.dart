import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../constant.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController nameController = TextEditingController();

  ConstantController constantController = Get.put(ConstantController());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            height: height * 0.35,
            width: width<=800?width * 0.8:width*0.5,
            decoration: const BoxDecoration(
                color: const Color(0xff00695c),
                borderRadius: const BorderRadius.all(const Radius.circular(10))),
            child: ListView(
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Request Password Reset",style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                        ),),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
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
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 50,
                                  width: width<=800?width * 0.3:width*0.2,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xffff5722), // This is what you need!
                                    ),
                                    child:const Text('Request Password Reset'),
                                    onPressed: () {
                                      nameController.clear();
                                      var res =   constantController.tbClient.sendResetPasswordLink(nameController.text);
                                      Get.snackbar("Success", "Reset link is send to your email",colorText: Colors.white,backgroundColor: Colors.green);
                                    },
                                  )),
                              Container(
                                  height: 50,
                                  width: width<=800?width * 0.2:width*0.1,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xff00c3b6), // This is what you need!
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
