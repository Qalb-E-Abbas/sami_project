import 'package:flutter/material.dart';
import 'package:sami_project/common/appButton.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/common/textfromfield.dart';
import 'package:sami_project/screens/MainScreens/student_map_screen.dart';
import 'package:sami_project/screens/AuthScreens/student_registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              VerticalSpace(20),

              Center(child: Image.asset('assets/Asset 1.png')),

              VerticalSpace(30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  DynamicFontSize(label:
                  'Login',
                    fontSize: 26,),

                  VerticalSpace(40),

                  DynamicFontSize(label: 'Email:', fontSize: 20),

                  VerticalSpace(10),

                  AppTextFormField(hintText: 'qalbeabbas964@gmail.com'),

                  VerticalSpace(10),


                  DynamicFontSize(label: 'Password:', fontSize: 20),

                  VerticalSpace(10),

                  AppTextFormField( hintText: 'Enter Password'),

                  VerticalSpace(10),

                  Align(
                    alignment: Alignment.topRight,
                    child:  DynamicFontSize(
                        label: 'Forgot Password?',
                        fontWeight: FontWeight.normal,
                        fontSize: 17),
                  ),

                  VerticalSpace(20),

                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(


                          PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (_, animation, __){
                                return FadeTransition(
                                    opacity: animation,
                                    child: MainScreen()
                                );
                              })


                      );
                    },
                    child: AppButton(
                      label: 'Login', colorText: '#3B7AF8',),
                  ),

                  VerticalSpace(40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      DynamicFontSize(
                          label: 'Don\'t have an account?',
                          fontSize: 18),

                        HorizontalSpace(6),

                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(


                              PageRouteBuilder(
                                  transitionDuration: const Duration(seconds: 1),
                                  pageBuilder: (_, animation, __){
                                    return ScaleTransition(
                                        scale: animation,
                                        child: StudentRegistration()
                                    );
                                  })


                          );
                        },
                        child: DynamicFontSize(
                          label: 'Register',
                          fontSize: 18,
                          color: AppColors().colorFromHex(context, '#3B7AF8'),),
                      ),

                    ],
                  )

                ],
              ),
              ),

              VerticalSpace(20),




            ],
          ),
        ),
      ),
    );
  }
}
