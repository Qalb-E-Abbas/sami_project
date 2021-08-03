import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/application/applicationChatBznzLogic.dart';
import 'package:sami_project/common/back_end_configs.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/horizontal_sized_box.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/infrastructure/models/messagesModel.dart';
import 'package:sami_project/infrastructure/models/userModel.dart';
import 'package:sami_project/infrastructure/services/chatServices.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';

class TeacherChatScreen extends StatefulWidget {
  final String sendToID;
  final String sendByID;
  final String chatID;
  final List<MessagesModel> messages;
  final String userID;
  final bool isTeacher;

  TeacherChatScreen(
      {this.sendToID,
      this.sendByID,
      this.chatID,
      this.messages,
      this.userID,
      this.isTeacher});

  @override
  _TeacherChatScreenState createState() => _TeacherChatScreenState();
}

class _TeacherChatScreenState extends State<TeacherChatScreen> {
  ChatBusinessLogic _chatLogic = ChatBusinessLogic();
  ChatServices _advisorChatServices = ChatServices();

  TextEditingController messageController = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);

  bool initialized = false;

  StudentModel userModel = StudentModel();
  UserServices _userServices = UserServices();

  @override
  void dispose() {
    // TODO: implement dispose
    if (widget.messages != null)
      widget.messages.map((e) {
        _advisorChatServices.markMessageAsRead(
            context, getChatID(), widget.userID);
      }).toList();
    if (widget.isTeacher)
      _userServices.changeOnlineStatusTeacher(
          docID: widget.userID, isOnline: false);
    if (!widget.isTeacher)
      _userServices.changeOnlineStatusStudents(
          docID: widget.userID, isOnline: false);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.messages != null)
      widget.messages.map((e) {
        _advisorChatServices.markMessageAsRead(context, getChatID(), e.docID);
      }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print("CHAT ID: ${widget.userID}");
    if (widget.isTeacher)
      _userServices.changeOnlineStatusTeacher(
          docID: widget.userID, isOnline: true);
    if (!widget.isTeacher)
      _userServices.changeOnlineStatusStudents(
          docID: widget.userID, isOnline: true);
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      body: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!initialized) {
              var items =
                  storage.getItem(BackEndConfigs.userDetailsLocalStorage);
              var std =
                  storage.getItem(BackEndConfigs.teacherDetailsLocalStorage);
              print(items);
              print(std);
              if (items != null) {
                userModel = StudentModel(
                  id: items['id'],
                  name: items['name'],
                  isOnline: items['isOnline'],
                  email: items['email'],
                );
              }
              if (std != null) {
                userModel = StudentModel(
                  id: std['id'],
                  name: std['name'],
                  isOnline: std['isOnline'],
                  email: std['email'],
                );
              }

              initialized = true;
            }
            return snapshot.data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _getUI(context);
          }),
    );
  }

  Widget _getUI(BuildContext context) {
    print("IDS : ${userModel.id}");
    return StreamProvider.value(
      value: _userServices.streamStudentsData(getMyID()),
      builder: (ctxt, child) {
        return (ctxt.watch<StudentModel>() == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Scaffold(
                  body: Container(
                    child: Column(
                      children: [
                        Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blue,
                            child: Center(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (_) =>
                                          //             StudentsHomeView()));
                                        },
                                        child: Image.asset(
                                          'assets/images/back.png',
                                          height: 26,
                                          width: 26,
                                        ),
                                      ),
                                      HorizontalSpace(15),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (_) => TeacherProfileView(widget.image)
                                          //     ));
                                        },
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage("" ?? ""),
                                        ),
                                      ),
                                      HorizontalSpace(10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DynamicFontSize(
                                              label: ctxt
                                                  .watch<StudentModel>()
                                                  .name,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            VerticalSpace(2),
                                            DynamicFontSize(
                                              label: ctxt
                                                      .watch<StudentModel>()
                                                      .isOnline
                                                  ? "Online"
                                                  : "Offline",
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.black,
                                        size: 24,
                                      )
                                    ],
                                  ),
                                ]))),
                        Expanded(
                          child: Container(
                            child: StreamProvider.value(
                              value: _advisorChatServices.getMessages(
                                  context, getChatID()),
                              builder: (msjContext, child) {
                                return StreamProvider.value(
                                  value: _advisorChatServices.getMsjsToRead(
                                      context, getChatID(), getMyID()),
                                  builder: (markReadMsjContext, child) {
                                    Timer(
                                        Duration(milliseconds: 300),
                                        () => _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 700),
                                            curve: Curves.ease));
                                    return msjContext
                                                .watch<List<MessagesModel>>() ==
                                            null
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ListView.builder(
                                            controller: _scrollController,
                                            itemCount: msjContext
                                                .watch<List<MessagesModel>>()
                                                .length,
                                            itemBuilder: (context, i) {
                                              if (markReadMsjContext.watch<
                                                      List<MessagesModel>>() !=
                                                  null) if (markReadMsjContext.watch<List<MessagesModel>>().isNotEmpty)
                                                markReadMsjContext
                                                    .watch<
                                                        List<MessagesModel>>()
                                                    .map((e) =>
                                                        // print(e.messageBody)
                                                        _advisorChatServices
                                                            .markMessageAsRead(
                                                          context,
                                                          getChatID(),
                                                          widget.userID,
                                                        ))
                                                    .toList();

                                              return MessageTile(
                                                message: msjContext
                                                    .watch<
                                                        List<
                                                            MessagesModel>>()[i]
                                                    .messageBody,
                                                sendByMe: msjContext
                                                        .watch<
                                                            List<
                                                                MessagesModel>>()[
                                                            i]
                                                        .sendID ==
                                                    userModel.id,
                                                time: "12:00",
                                              );
                                            });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  controller: messageController,
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Type Here...",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                )),
                                SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (messageController.text.isEmpty) {
                                      return;
                                    }

                                    Timer(
                                        Duration(milliseconds: 300),
                                        () => _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 700),
                                            curve: Curves.ease));
                                    _chatLogic
                                        .initChat(context,
                                            chatID: getChatID(),
                                            model: MessagesModel(
                                                senderName: userModel.name,
                                                isRead: false,
                                                sendID: userModel.id,
                                                messageBody:
                                                    messageController.text,
                                                time: DateTime.now()
                                                    .millisecondsSinceEpoch))
                                        .then((value) async {
                                      {
                                        messageController.clear();
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: messageController.text.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
      },
    );
  }

  getChatID() {
    if (widget.sendByID != null) {
      return widget.sendByID + "_" + widget.sendToID;
    } else {
      return widget.chatID;
    }
  }

  getMyID() {
    if (widget.sendByID != null) {
      return widget.sendToID;
    } else {
      return widget.chatID.replaceAll("_", "").replaceAll(widget.userID, "");
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final time;
  final date;

  MessageTile(
      {@required this.message, @required this.sendByMe, this.time, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: 2,
              bottom: 1,
              left: sendByMe ? 0 : 14,
              right: sendByMe ? 14 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: 0.6 * MediaQuery.of(context).size.width),
            margin: sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
            decoration: BoxDecoration(
              color: sendByMe ? Colors.white : Color(0xffc8f7c5),
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message ?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        height: 1.3,
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w300)),
                VerticalSpace(5),
                Text(
                  time,
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
