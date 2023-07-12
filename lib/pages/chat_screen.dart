import 'package:auto_reload/auto_reload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/services/chat_services.dart';
import 'package:takasapp/utility/my_text_field.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:takasapp/utility/project_colors.dart';

import '../services/model/message_modal.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String adsId;
  final String receiverUserID;
  const ChatPage(
      {super.key,
      required this.chatName,
      required this.receiverUserID,
      required this.adsId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

abstract class _AutoReloadState extends State<ChatPage>
    implements AutoReloader {}

class _ChatPageState extends _AutoReloadState with AutoReloadMixin {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    startAutoReload();
    super.initState();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.chatName, widget.adsId,
          widget.receiverUserID, _messageController.text);

      _messageController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(widget.chatName),
                backgroundColor: ProjectColor.mainColor),
            body: Column(
              children: [
                Expanded(
                  child: _buildMessageList(),
                ),
                _buildMessageInput()
              ],
            )));
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserID, widget.adsId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var aligment = (data["senderId"] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: aligment,
        child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ProjectColor.mainColor),
            child: Text(
              data["message"],
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //textfield
        Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter Message',
                obscureText: false)),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward_rounded,
              size: 40,
            ))
      ],
    );
  }

  @override
  void autoReload() {
    setState(() {
      _chatService.getMessages(widget.receiverUserID, widget.adsId);
    });
  }
}
