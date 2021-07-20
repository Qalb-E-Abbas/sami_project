import 'package:flutter/material.dart';
import 'package:sami_project/common/appButton.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/screens/AuthScreens/student_registration.dart';
import 'package:sami_project/screens/AuthScreens/teacher_registration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/our-students.png'),
                          fit: BoxFit.fill
                      )
                  ),
                ),

                VerticalSpace(30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      DynamicFontSize(label:
                      'Register Yourself',
                        fontSize: 26,),

                      VerticalSpace(40),

                      InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(


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
                          child: AppButton(label: 'Student', colorText: '#00C97E',)),

                      VerticalSpace(20),

                      InkWell(
                          onTap: (){
                            Navigator.of(context).push(


                                PageRouteBuilder(
                                    transitionDuration: const Duration(seconds: 1),
                                    pageBuilder: (_, animation, __){
                                      return ScaleTransition(
                                          scale: animation,
                                          child: TeacherRegistration()
                                      );
                                    })


                            );
                          },
                          child: AppButton(label: 'Teacher', colorText: '#3B7AF8',)),

                    ],
                  )
                ),

                VerticalSpace(40),






              ],
            ),
          ),
        )
    );
  }
}
