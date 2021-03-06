import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/application/auth_state.dart';
import 'package:sami_project/application/errorStrings.dart';
import 'package:sami_project/application/loginBusinessLogic.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/appButton.dart';
import 'package:sami_project/common/dialog.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/enums.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/common/textfromfield.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/infrastructure/services/authServices.dart';
import 'package:sami_project/screens/MainScreens/teacher_profile_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var node;

  LoginBusinessLogic data = LoginBusinessLogic();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthServices>(context);
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DynamicFontSize(
                        label: 'Login',
                        fontSize: 26,
                      ),
                      VerticalSpace(40),
                      DynamicFontSize(label: 'Email:', fontSize: 20),
                      VerticalSpace(10),
                      AppTextFormField(
                        hintText: 'qalbeabbas964@gmail.com',
                        controller: _emailController,
                        validator: (val) =>
                            val.isEmpty ? "Field cannot be empty" : null,
                      ),
                      VerticalSpace(10),
                      DynamicFontSize(label: 'Password:', fontSize: 20),
                      VerticalSpace(10),
                      AppTextFormField(
                        hintText: 'Enter Password',
                        controller: _pwdController,
                        validator: (val) =>
                            val.isEmpty ? "Field cannot be empty" : null,
                      ),
                      VerticalSpace(10),
                      Align(
                        alignment: Alignment.topRight,
                        child: DynamicFontSize(
                            label: 'Forgot Password?',
                            fontWeight: FontWeight.normal,
                            fontSize: 17),
                      ),
                      VerticalSpace(20),
                      InkWell(
                        onTap: () {},
                        child: AppButton(
                          onTap: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            loginUser(
                                context: context,
                                data: data,
                                email: _emailController.text,
                                auth: auth,
                                password: _pwdController.text);
                          },
                          label: 'Login',
                          colorText: '#3B7AF8',
                        ),
                      ),
                      VerticalSpace(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DynamicFontSize(
                              label: 'Don\'t have an account?', fontSize: 18),
                          HorizontalSpace(6),
                          InkWell(
                            onTap: () {},
                            child: DynamicFontSize(
                              label: 'Register',
                              fontSize: 18,
                              color:
                                  AppColors().colorFromHex(context, '#3B7AF8'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              VerticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  loginUser(
      {@required BuildContext context,
      @required LoginBusinessLogic data,
      @required String email,
      @required AuthServices auth,
      @required String password}) {
    data
        .teacherLoginUserLogic(
      context,
      email: email,
      password: password,
    )
        .then((val) async {
      if (auth.status == Status.Authenticated) {
        UserLoginStateHandler.saveUserLoggedInSharedPreference(true);
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, animation, __) {
              return ScaleTransition(scale: animation, child: ProfilePage());
            }));
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}
