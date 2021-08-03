import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sami_project/common/AppColors.dart';
import 'package:sami_project/common/back_end_configs.dart';
import 'package:sami_project/common/customOnlineDot.dart';
import 'package:sami_project/common/dynamicFontSize.dart';
import 'package:sami_project/common/vertical_sized_box.dart';
import 'package:sami_project/infrastructure/models/chatModel.dart';
import 'package:sami_project/infrastructure/models/messagesModel.dart';
import 'package:sami_project/infrastructure/models/userModel.dart';
import 'package:sami_project/infrastructure/services/chatServices.dart';
import 'package:sami_project/infrastructure/services/user_services.dart';
import 'package:sami_project/screens/MainScreens/chat_screen.dart';
import 'package:sami_project/screens/MainScreens/stdChatList.dart';

class ChatList extends StatefulWidget {
  final String id;
  final bool isTeacher;
  ChatList(this.id, this.isTeacher);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);

  bool initialized = false;
  int i = 0;
  bool isSearchingAllow = false;

  bool isSearched = false;
  StudentModel userModel = StudentModel();
  bool isDone = false;
  List<ChatModel> chatModel = [];
  ChatServices _chatServices = ChatServices();
  UserServices _userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!initialized) {
              var items =
                  storage.getItem(BackEndConfigs.userDetailsLocalStorage);

              var teachers =
                  storage.getItem(BackEndConfigs.teacherDetailsLocalStorage);
              if (items != null) {
                print(items);
                userModel = StudentModel(
                  id: items['id'],
                );
              }

              if (teachers != null) {
                userModel = StudentModel(
                  id: teachers['id'],
                );
              }

              initialized = true;
            }
            return snapshot.data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _getUI(context, userModel);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ContactList()));
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    // _userServices.changeOnlineStatus(
    //     userModel: UserModel(docID: widget.id), isOnline: false);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement dispose

    // _userServices.changeOnlineStatus(
    //     userModel: UserModel(docID: widget.id), isOnline: true);
    super.initState();
  }

  Widget _getUI(BuildContext context, StudentModel model) {
    var user = Provider.of<User>(context);
    return model == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  VerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 170),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                      color: AppColors.scaffoldBackgroundColor,
                    ),
                  ),
                  StreamProvider.value(
                    value: _chatServices.getChatList(context, docID: widget.id),
                    builder: (context, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ListView.separated(
                            separatorBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5),
                                child: Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Colors.blue,
                                ),
                              );
                            },
                            itemCount: context.watch<List<ChatModel>>().length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return StreamProvider.value(
                                value: _userServices.streamStudentsData(context
                                    .read<List<ChatModel>>()[index]
                                    .chatID
                                    .replaceAll("_", "")
                                    .replaceAll(user.uid, "")),
                                builder: (c, child) {
                                  return StreamProvider.value(
                                    value: _chatServices.getUnreadMessagesCount(
                                        context,
                                        context
                                            .read<List<ChatModel>>()[index]
                                            .chatID,
                                        userModel.id),
                                    builder: (chatCountContext, child) {
                                      return c.watch<StudentModel>() == null ||
                                              chatCountContext.watch<
                                                      List<MessagesModel>>() ==
                                                  null
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  ChatModel cModel =
                                                      context.read<
                                                              List<
                                                                  ChatModel>>()[
                                                          index];
                                                  setState(() {});

                                                  if (widget.isTeacher) {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (builder) =>
                                                            TeacherChatScreen(
                                                                isTeacher: true,
                                                                userID:
                                                                    userModel
                                                                        .id,
                                                                messages:
                                                                    chatCountContext
                                                                        .watch<
                                                                            List<
                                                                                MessagesModel>>(),
                                                                chatID: cModel
                                                                    .chatID)));
                                                  } else {
                                                    print(userModel.id);
                                                    return;
                                                    Navigator.of(
                                                            context)
                                                        .push(MaterialPageRoute(
                                                            builder: (builder) => ChatScreen(
                                                                isTeacher:
                                                                    false,
                                                                userID:
                                                                    userModel
                                                                        .id,
                                                                messages:
                                                                    chatCountContext
                                                                        .watch<
                                                                            List<
                                                                                MessagesModel>>(),
                                                                chatID: cModel
                                                                    .chatID)));
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Center(
                                                    child: Card(
                                                      elevation: 4,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: ListTile(
                                                        leading: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      'assets/images/placeholderUser.png'),
                                                              radius: 30,
                                                            ),
                                                            c
                                                                    .watch<
                                                                        StudentModel>()
                                                                    .isOnline
                                                                ? Positioned(
                                                                    bottom: 0,
                                                                    right: 3,
                                                                    child: customOnlineDot(
                                                                        Colors
                                                                            .green),
                                                                  )
                                                                : Positioned(
                                                                    bottom: 0,
                                                                    right: 3,
                                                                    child: customOnlineDot(
                                                                        Colors
                                                                            .grey),
                                                                  ),
                                                          ],
                                                        ),
                                                        subtitle: Text(context
                                                            .watch<
                                                                List<
                                                                    ChatModel>>()[
                                                                index]
                                                            .lastMessage),
                                                        title: Text(c
                                                            .watch<
                                                                StudentModel>()
                                                            .name),
                                                        trailing: chatCountContext
                                                                    .watch<
                                                                        List<
                                                                            MessagesModel>>()
                                                                    .length !=
                                                                0
                                                            ? Container(
                                                                height: 24,
                                                                width: 24,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .blue),
                                                                child: Center(
                                                                  child:
                                                                      DynamicFontSize(
                                                                    label: chatCountContext
                                                                        .read<
                                                                            List<MessagesModel>>()
                                                                        .length
                                                                        .toString(),
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 24,
                                                                width: 24,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              );
                            }),
                      );
                    },
                  )
                ],
              ),
            ),
          );
  }
}
