import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sami_project/common/appButton.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/common/textfromfield.dart';


class TeacherRegistration extends StatefulWidget {
  const TeacherRegistration({Key key}) : super(key: key);

  @override
  _TeacherRegistrationState createState() => _TeacherRegistrationState();
}

class _TeacherRegistrationState extends State<TeacherRegistration> {

  Completer<GoogleMapController> _completer = Completer();


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
                        fit: BoxFit.fill
                    )
                ),
              ),

              VerticalSpace(20),

              Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    DynamicFontSize(label: 'Name:', fontSize: 20),

                    VerticalSpace(10),

                    AppTextFormField( hintText: 'Qalb E Abbas'),

                    VerticalSpace(10),

                    DynamicFontSize(label: 'Email:', fontSize: 20),

                    VerticalSpace(10),

                    AppTextFormField(hintText: 'qalbeabbas964@gmail.com'),

                    VerticalSpace(10),


                    DynamicFontSize(label: 'Password:', fontSize: 20),

                    VerticalSpace(10),

                    AppTextFormField( hintText: 'Enter Password'),

                    VerticalSpace(10),


                    DynamicFontSize(label: 'Confirm Password:', fontSize: 20),

                    VerticalSpace(10),

                    AppTextFormField( hintText: 'Re-enter Password'),

                    VerticalSpace(10),


                    DynamicFontSize(label: 'Qualification:', fontSize: 20),

                    VerticalSpace(10),

                    AppTextFormField( hintText: 'BS/MS in Computer Science'),

                    VerticalSpace(20),

                    DynamicFontSize(label: 'Location', fontSize: 20),

                    VerticalSpace(10),

                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          zoom: 10,
                          target: LatLng(40.712776,  -74.005974,)
                        ),
                        onMapCreated: (GoogleMapController controller){
                          _completer.complete(controller);
                        },
                      ),
                    ),

                    VerticalSpace(10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                             child: Container(
                               height: 34,
                               width: 34,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: AppColors().colorFromHex(context, '#3B7AF8')
                               ),
                               child: Icon(
                                 Icons.add, color: Colors.white,
                               ),
                             ),
                          ),

                          Row(
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  color: AppColors().colorFromHex(context, '#3B7AF8')),
                              HorizontalSpace(10),
                              DynamicFontSize(label: 'BS in computer science',
                                  fontSize: 18, fontWeight: FontWeight.normal,)

                            ],
                          )

                        ],
                      ),
                    ),

                    VerticalSpace(20),

                    AppButton(label: 'Register', colorText: '#3B7AF8',),

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
}
