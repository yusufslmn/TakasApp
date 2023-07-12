import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Message(
      message: data["message"],
      senderId: data["senderId"],
      timestamp: data["timestamp"],
    );
  }
}

class UserMessage {
  final List<dynamic> members;
  final String chatName;
  final String adsId;

  UserMessage(
      {required this.members, required this.adsId, required this.chatName});

  factory UserMessage.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserMessage(
        members: data["members"],
        adsId: data['adsId'],
        chatName: data['chatName']);
  }
}
