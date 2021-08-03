import 'package:flutter/material.dart';
import 'package:sami_project/infrastructure/models/chatModel.dart';
import 'package:sami_project/infrastructure/models/messagesModel.dart';
import 'package:sami_project/infrastructure/services/chatServices.dart';

class ChatBusinessLogic {
  ChatServices _chatServices = ChatServices();

  ///Create New Chat
  Future<void> initChat(BuildContext context,
      {String chatID, MessagesModel model}) async {
    print("chatID : ${chatID}");
    _chatServices
        .startChat(
            context,
            ChatModel(lastMessage: model.messageBody, chatID: chatID, users: [
              chatID.split("_")[0],
              chatID.split("_")[1],
            ]))
        .then((value) {
      print("Value ID: ${value.id}");
      _chatServices.startMessage(context, model: model, chatID: value.id);
    });
  }
}
