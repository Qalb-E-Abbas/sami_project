import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/common/textfromfield.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  Completer<GoogleMapController> _completer = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
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

            Positioned(
              top: 30,
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search, size: 30,),
                      ),
                      Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search here..',
                              border: InputBorder.none
                            ),
                          )
                      ),

                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          color: AppColors().colorFromHex(context, '#3B7AF8')
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_forward, size: 30,
                            color:AppColors.scaffoldBackgroundColor,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),


            Positioned(
              left: 10,
              top: 110,
              child: Row(
                children: [

                  Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors().colorFromHex(context, '#3B7AF8'),
                    ),
                    child: Center(
                      child: DynamicFontSize(
                        label: 'Search by subject',
                        fontSize: 18,
                        color: AppColors.scaffoldBackgroundColor,
                      ),
                    ),
                  ),

                  HorizontalSpace(10),

                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.scaffoldBackgroundColor,
                    ),
                    child: Center(
                      child: DynamicFontSize(
                        label: 'Near By',
                        fontSize: 18,
                        color: AppColors().colorFromHex(context, '#3B7AF8'),
                      ),
                    ),
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
