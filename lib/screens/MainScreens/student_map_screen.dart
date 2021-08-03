import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';
import 'package:sami_project/screens/MainScreens/teacher_profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _completer = Completer();
  UserServices _userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Teachers List"),
      ),
      body: StreamProvider.value(
        value: _userServices.getAllTeachers(context),
        builder: (context, child) {
          return context.watch<List<TeacherModel>>() == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: context.watch<List<TeacherModel>>().length,
                  itemBuilder: (ctxt, i) {
                    return ListTile(
                      onTap: () {
                        TeacherModel model =
                            context.read<List<TeacherModel>>()[i];
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      teacherModel: model,
                                      isOutsideRoute: true,
                                      myID: user.uid,
                                    )));
                      },
                      title: Text(context.watch<List<TeacherModel>>()[i].name),
                    );
                  });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ChatList("")));
        },
      ),
    );
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
                    target: LatLng(
                      40.712776,
                      -74.005974,
                    )),
                onMapCreated: (GoogleMapController controller) {
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
                    borderRadius: BorderRadius.circular(10)),
                child: Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                      Flexible(
                          child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Search here..',
                            border: InputBorder.none),
                      )),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                AppColors().colorFromHex(context, '#3B7AF8')),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: AppColors.scaffoldBackgroundColor,
                          ),
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
