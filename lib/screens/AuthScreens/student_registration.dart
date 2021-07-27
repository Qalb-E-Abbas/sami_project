import 'package:flutter/material.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/appButton.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/textfromfield.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/screens/AuthScreens/login_screen.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key key}) : super(key: key);

  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
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
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/our-students.png'),
                        fit: BoxFit.fill)),
              ),
              VerticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DynamicFontSize(label: 'Name:', fontSize: 20),
                    VerticalSpace(10),
                    AppTextFormField(hintText: 'Qalb E Abbas'),
                    VerticalSpace(10),
                    DynamicFontSize(label: 'Email:', fontSize: 20),
                    VerticalSpace(10),
                    AppTextFormField(hintText: 'qalbeabbas964@gmail.com'),
                    VerticalSpace(10),
                    DynamicFontSize(label: 'Password:', fontSize: 20),
                    VerticalSpace(10),
                    AppTextFormField(hintText: 'Enter Password'),
                    VerticalSpace(10),
                    DynamicFontSize(label: 'Confirm Password:', fontSize: 20),
                    VerticalSpace(10),
                    AppTextFormField(hintText: 'Re-enter Password'),
                    VerticalSpace(10),
                    DynamicFontSize(label: 'Address:', fontSize: 20),
                    VerticalSpace(10),
                    AppTextFormField(hintText: 'KUST, KPK'),
                    VerticalSpace(20),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (_, animation, __) {
                                return FadeTransition(
                                    opacity: animation, child: LoginScreen());
                              }));
                        },
                        child: AppButton(
                          label: 'Register',
                          colorText: '#3B7AF8',
                        )),
                    VerticalSpace(20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// _signUpUser(
//     {BuildContext context,
//       @required SignUpBusinessLogic signUp,
//       @required User user}) {
//   signUp
//       .registerNewTeacher(
//       email: _emailController.text,
//       password: _pwdController.text,
//       teacherModel: TeacherModel(
//           name: _nameController.text,
//           email: _emailController.text,
//           password: _pwdController.text,
//           lat: 12,
//           lng: 12,
//           role: "T",
//           subjectID: "2",
//           subjectName: "Maths",
//           qualification: _qualController.text),
//       context: context,
//       user: user)
//       .then((value) {
//     if (signUp.status == SignUpStatus.Registered) {
//       showNavigationDialog(context,
//           message:
//           "Thanks for registration. Go to Login to access your dashboard.",
//           buttonText: "Go To Login", navigation: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => LoginScreen()));
//           }, secondButtonText: "", showSecondButton: false);
//     } else if (signUp.status == SignUpStatus.Failed) {
//       showErrorDialog(context,
//           message: Provider.of<ErrorString>(context, listen: false)
//               .getErrorString());
//     }
//   });
// }
}
