import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';
import 'package:sami_project/screens/MainScreens/teacher_profile_page.dart';

class MapHomePage extends StatefulWidget {
  @override
  MapHomePageState createState() => MapHomePageState();
}

class MapHomePageState extends State<MapHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  UserServices _userServices = UserServices();

  bool isLoading = true;
  List<DocumentSnapshot> shopsData = [];
  List<Marker> marker = [];

  var _lat;
  var _lng;

  @override
  void initState() {
    shopsData.clear();

    super.initState();
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Google Map"),
      ),
      body: StreamProvider.value(
        value: _userServices.getAllTeachers(context),
        builder: (context, child) {
          if (context.read<List<TeacherModel>>() != null) if (marker.length <
              context.read<List<TeacherModel>>().length)
            Future.delayed(Duration(milliseconds: 300), () {
              context
                  .read<List<TeacherModel>>()
                  .map((e) => marker.add(Marker(
                      markerId: MarkerId(e.id),
                      position: LatLng(double.parse(e.lat.toString()),
                          double.parse(e.lng.toString())),
                      infoWindow: InfoWindow(title: e.name),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueViolet,
                      ))))
                  .toList();
              setState(() {});
            });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGoogleMap(context),
              context.watch<List<TeacherModel>>() == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: context.watch<List<TeacherModel>>().length,
                          itemBuilder: (c, i) {
                            return Card(
                              elevation: 4,
                              child: Container(
                                width: 100,
                                height: 100,
                                child: ListTile(
                                  onTap: () {
                                    _gotoLocation(
                                        double.parse(context
                                            .read<List<TeacherModel>>()[i]
                                            .lat
                                            .toString()),
                                        double.parse(context
                                            .read<List<TeacherModel>>()[i]
                                            .lng
                                            .toString()));
                                  },
                                  title: Text(context
                                      .watch<List<TeacherModel>>()[i]
                                      .name),
                                  trailing: IconButton(
                                    icon: Icon(Icons.person),
                                    onPressed: () {
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
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(10, 10), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(marker),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

List<MarkerDetails> markerDetails = [
  MarkerDetails(
      markerID: 'gramercy',
      lat: 40.738380,
      lng: -73.988426,
      title: 'Gramercy Tavern'),
  MarkerDetails(
      markerID: 'gramesdfrcy',
      lat: 40.742451,
      lng: -74.005959,
      title: 'Gramercy Tavern')
];

class MarkerDetails {
  final String markerID;
  final double lat;
  final double lng;
  final title;

  MarkerDetails({this.markerID, this.lat, this.lng, this.title});
}
