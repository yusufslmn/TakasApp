import 'package:auto_reload/auto_reload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/services/chat_services.dart';
import 'package:takasapp/utility/project_colors.dart';

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
  // ignore: library_private_types_in_public_api
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
      await _chatService
          .sendMessage(widget.chatName, widget.adsId, widget.receiverUserID,
              _messageController.text)
          .whenComplete(() => _messageController.clear());
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
    final Timestamp time = data['timestamp'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: aligment,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ProjectColor.mainColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:
                  (data["senderId"] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  data["message"],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "${time.toDate().hour.toString()} :${time.toDate().minute.toString()} ",
                  style: const TextStyle(fontSize: 10),
                )
              ],
            )),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: ProjectColor.mainColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: ProjectColor.mainColor)),
                    hintText: 'Enter message',
                    suffixIcon: IconButton(
                        onPressed: sendMessage,
                        icon: Icon(
                          CupertinoIcons.arrow_turn_down_right,
                          size: 40,
                          color: ProjectColor.mainColor,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200))),
              )),
        )
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
