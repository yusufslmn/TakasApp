import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takasapp/utility/project_colors.dart';
import 'package:auto_reload/auto_reload.dart';
import '../../services/chat_services.dart';
import 'chat_screen.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessagesState createState() => _MessagesState();
}

abstract class _AutoReloadState extends State<Messages>
    implements AutoReloader {}

class _MessagesState extends _AutoReloadState with AutoReloadMixin {
  final ChatService _chatService = ChatService();
  String? currentUser = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  @override
  void initState() {
    startAutoReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: ProjectColor.mainColor,
            title: const Text("Mesajlarım"),
          ),
          body: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMessageList(),
            ),
          )),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getUserMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    List<dynamic> members = data["members"];
    members.remove(currentUser);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatPage(
                  adsId: data["adsId"],
                  receiverUserID: members.first,
                  chatName: data["chatName"],
                ))),
        trailing: Icon(CupertinoIcons.arrow_turn_down_right),
        shape: StadiumBorder(side: BorderSide(color: ProjectColor.mainColor)),
        title: Text(data["chatName"]),
      ),
    );
  }

  @override
  void autoReload() {
    setState(() {
      _chatService.getUserMessages();
    });
  }
}
