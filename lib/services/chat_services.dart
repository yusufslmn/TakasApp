import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/services/model/message_modal.dart';
import 'package:takasapp/services/send_notification.dart';
import 'package:takasapp/services/user_service.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // SEND Message
  Future<void> sendMessage(
      String chatName, String adsId, String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    List<String> members = [receiverId, currentUserId];
    members.sort();
    // ignore: prefer_interpolation_to_compose_strings
    String chatId = members.join("_") + "_" + adsId;
    // create a new message
    Message newMessage = Message(
        senderId: currentUserId, message: message, timestamp: timestamp);
    final UserService _service = UserService();
    late final TokenModal token;
    late final TokenModal name;

    token = await _service.getUser(receiverId);
    name = await _service.getUser(currentUserId);
    await _db
        .collection("chats")
        .doc(chatId)
        .set({'members': members, 'adsId': adsId, 'chatName': chatName});
    await _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(newMessage.toMap());
    await sendFCMMessage(token.userToken!, name.userName!, message);
  }

// get messages
  Stream<QuerySnapshot> getMessages(String receiverId, String adsId) {
    final db = FirebaseFirestore.instance;
    List<String> members = [receiverId, _firebaseAuth.currentUser!.uid];
    members.sort();
    // ignore: prefer_interpolation_to_compose_strings
    String chatId = members.join("_") + "_" + adsId;
    return db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserMessages() {
    final db = FirebaseFirestore.instance;
    return db
        .collection("chats")
        .where('members', arrayContains: _firebaseAuth.currentUser!.uid)
        .snapshots();
  }
}
