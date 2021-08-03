import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sami_project/infrastructure/models/chatModel.dart';
import 'package:sami_project/infrastructure/models/messagesModel.dart';

class ChatServices {
  ///Start Chat
  Future<DocumentReference> startChat(
      BuildContext context, ChatModel model) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('chatCollection')
        .doc(model.chatID);
    print("MODEL : ${model.chatID}");

    docRef.set(model.toJson());
    return docRef;
  }

  ///Start Messages
  Future<void> startMessage(BuildContext context,
      {MessagesModel model, String chatID}) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('chatCollection')
        .doc(chatID)
        .collection('messages')
        .doc();
    return await docRef.set(model.toJson(docRef.id));
  }

  ///Get Chats List
  Stream<List<ChatModel>> getChatList(BuildContext context, {String docID}) {
    print("DOC ID : $docID");
    return FirebaseFirestore.instance
        .collection('chatCollection')
        .where('users', arrayContains: docID)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ChatModel.fromJson(e.data())).toList());
  }

  ///Get Messages
  Stream<List<MessagesModel>> getMessages(BuildContext context, String chatID) {
    return FirebaseFirestore.instance
        .collection('chatCollection')
        .doc(chatID)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessagesModel.fromJson(e.data())).toList());
  }

  ///Get Unread Messages Count
  Stream<List<MessagesModel>> getUnreadMessagesCount(
      BuildContext context, String chatID, String docID) {
    return FirebaseFirestore.instance
        .collection('chatCollection')
        .doc(chatID)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('sendID', isNotEqualTo: docID)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessagesModel.fromJson(e.data())).toList());
  }

  Stream<List<MessagesModel>> getMsjsToRead(
      BuildContext context, String chatID, String docID) {
    return FirebaseFirestore.instance
        .collection('chatCollection')
        .doc(chatID)
        .collection('messages')
        // .where('isRead', isEqualTo: false)
        .where('sendID', isEqualTo: docID)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessagesModel.fromJson(e.data())).toList());
  }

  ///Mark Message as Read
  Future<void> markMessageAsRead(
      BuildContext context, String chatID, String docID) async {
    print("HI DOC ID : $docID");
    // return await FirebaseFirestore.instance
    //     .collection('chatCollection')
    //     .doc(chatID)
    //     .collection('messages')
    //     .doc(docID)
    //     .update({'isRead': true});
  }
}
