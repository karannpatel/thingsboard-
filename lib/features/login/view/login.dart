import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsboard/constant.dart';
import 'package:thingsboard/features/dashboard/view/dashboard.dart';
import 'package:thingsboard/features/login/view/forgetPassword.dart';

import 'package:thingsboard_pe_client/thingsboard_client.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visiblePassword = false;
  ConstantController constantController = Get.put(ConstantController());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            height: height * 0.6,
            width: width<=800?width * 0.8:width*0.5,
            decoration: const BoxDecoration(
                color: Color(0xff00695c),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListView(
                shrinkWrap: true,
                children: [
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center ,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 200,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        semanticsLabel: "logo",
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return "Enter email";
                        }
                        return null;
                      },
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: visiblePassword,
                      controller: passwordController,
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return "Enter Password";
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          child: visiblePassword?const Icon(Icons.visibility,color: Colors.white,):const Icon(Icons.visibility_off,color: Colors.white),
                          onTap: (){
                            setState((){
                              visiblePassword=!visiblePassword;
                            });
                          },
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(ForgetPasswordPage());
                    //forgot password screen
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
                  Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffff5722), // This is what you need!
                          ),
                          child: const Text('Login'),
                          onPressed: ()async {
                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            try{
                              var res =await constantController.tbClient.login(LoginRequest('babylon99_de@gmx.de', 'Iot123!!'));
                              //var res =await constantController.tbClient.login(LoginRequest(nameController.text, passwordController.text));
                              print(constantController.tbClient.getAuthUser());
                              if(constantController.tbClient.isAuthenticated())

                                sharedPreferences.setString('token', constantController.tbClient.getJwtToken()!);
                              constantController.tbClient.setUserFromJwtToken(constantController.tbClient.getJwtToken(), constantController.tbClient.getRefreshToken(), true);
                              Get.to(DashboardScreen());
                            }
                            catch(e){
                              print(e);
                            }
                            // loginController.login(nameController.text, passwordController.text);
                            //   nameController.clear();
                            //   passwordController.clear();
                          }
                      ))
            ]),
          ),
        ),
      ),
    );
  }
}
