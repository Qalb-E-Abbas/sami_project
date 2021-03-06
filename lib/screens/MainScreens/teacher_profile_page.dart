import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/back_end_configs.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isOpen = false;
  PanelController _panelController = PanelController();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  TeacherModel teacherModel = TeacherModel();
  bool initialized = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!initialized) {
                var items =
                    storage.getItem(BackEndConfigs.teacherDetailsLocalStorage);

                if (items != null) {
                  print(items);
                  teacherModel = TeacherModel(
                    email: items['email'],
                    name: items['name'],
                    subjectName: items['subjectName'],
                    hourlyRate: items['hourlyRate'],
                    location: items['location'],
                    bio: items['bio'],
                    contactNo: items['contactNo'],
                    exp: items['exp'],
                    image: items['image'],
                  );
                }

                initialized = true;
              }
              return snapshot.data == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _getUI(context);
            }));
  }

  Widget _getUI(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: 0.7,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(teacherModel.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.3,
          child: Container(
            color: Colors.white,
          ),
        ),

        /// Sliding Panel
        SlidingUpPanel(
          controller: _panelController,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(32),
          ),
          minHeight: MediaQuery.of(context).size.height * 0.35,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          body: GestureDetector(
            onTap: () => _panelController.close(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          panelBuilder: (ScrollController controller) => _panelBody(controller),
          onPanelSlide: (value) {
            if (value >= 0.2) {
              if (!_isOpen) {
                setState(() {
                  _isOpen = true;
                });
              }
            }
          },
          onPanelClosed: () {
            setState(() {
              _isOpen = false;
            });
          },
        ),
      ],
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          Container(
            height: 300,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bio:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customContainer(teacherModel.bio),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Contact No:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customContainer(teacherModel.contactNo),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Experience:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  customContainer('${teacherModel.exp} years'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlineButton(
                onPressed: () => _panelController.open(),
                borderSide: BorderSide(
                    color: AppColors().colorFromHex(context, '#3B7AF8')),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'VIEW PROFILE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: FlatButton(
                onPressed: () => print('Message tapped'),
                color: AppColors().colorFromHex(context, '#3B7AF8'),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'MESSAGE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(title: 'Projects', value: '1135'),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(
            title: 'Hourly Rate', value: "PKR ${teacherModel.hourlyRate}"),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Location', value: teacherModel.location),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({String title, String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    return Column(
      children: <Widget>[
        Text(
          teacherModel.name ?? "",
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          teacherModel.subjectName ?? "",
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  customContainer(String text) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: 50,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors().colorFromHex(context, '#3B7AF8'))),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
