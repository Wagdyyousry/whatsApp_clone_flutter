import 'dart:async';
import 'package:circular_image/circular_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/views/components/message_widget.dart';
import 'package:whats_app_clone/views/pages/view_image_page.dart';

// ignore: must_be_immutable
class GroupChatting extends StatefulWidget {
  GroupModel groupModel;
  GroupChatting({super.key, required this.groupModel});

  @override
  State<GroupChatting> createState() => _ChattingPage();
}

class _ChattingPage extends State<GroupChatting> {
  FirebaseDatabase dbRefrence = FirebaseDatabase.instance;
  TextEditingController messageController = TextEditingController();
  List<MessageModel> messageList = [];
  String? currentUserId;
  String? senderRoom, receiverRoom, receiverId;
  GroupModel groupModel = GroupModel();

  @override
  initState() {
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    groupModel = widget.groupModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 25),
        titleSpacing: 0,
        elevation: 10,
        shadowColor: const Color(0xFF0b6156),
        backgroundColor: const Color(0xFF0b6156),
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              height: 30,
              width: 30,
              child: CircularImage(
                  onImageTap: () {
                    if (groupModel.groupImageUri != null) {
                      Get.to(
                        ViewImagePage(image: groupModel.groupImageUri),
                      );
                    }
                  },
                  radius: 25,
                  borderWidth: 1.5,
                  borderColor: Colors.blue,
                  source: groupModel.groupImageUri ?? 'images/logo.png'),
            ),
            Text(
              groupModel.groupName.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg2.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(child: Consumer<RealtimeViewModel>(
              builder: (context, viewModel, child) {
                gettingGroupsMessages(viewModel);

                return ListView.builder(
                  reverse: true, // Start from the bottom
                  itemCount: messageList.length,
                  itemBuilder: (context, i) {
                    return messageList[i].senderId == currentUserId
                        ? MessageWidget(
                            isMe: true,
                            message: messageList[i].message!,
                            type: messageList[i].messageType!,
                            messageModel: messageList[i],
                          )
                        : MessageWidget(
                            isMe: false,
                            message: messageList[i].message!,
                            type: messageList[i].messageType!,
                            messageModel: messageList[i],
                          );
                  },
                );
              },
            )),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message.....',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      await sendingMessages();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendingMessages() async {
    String message = messageController.text.toString();
    if (message.isNotEmpty) {
      int time = DateTime.now().millisecondsSinceEpoch;
      messageController.text = "";

      await dbRefrence
          .ref()
          .child("GroupsChats")
          .child(groupModel.groupId!.toString())
          .push()
          .set({
        "message": message,
        "messageId": groupModel.groupId,
        "senderId": currentUserId,
        "receiverId": "",
        "time": time,
        "messageType": "message"
      });
    }
  }

  Future<void> gettingGroupsMessages(RealtimeViewModel viewModel) async {
    final newList = await viewModel.getGroupsMessages(groupModel.groupId!);
    if (messageList.isEmpty) {
      messageList = await viewModel.getGroupsMessages(groupModel.groupId!);
    } else if (messageList.length < newList.length) {
      messageList = await viewModel.getGroupsMessages(groupModel.groupId!);
    }
    setState(() {
      messageList.sort((a, b) => a.time!.compareTo(b.time!));
    });
  }
  // Future<void> gettingGroupsMessages(String groupId) async {
  //   FirebaseDatabase.instance
  //       .ref('GroupsChats')
  //       .child(groupId)
  //       .orderByChild("time")
  //       .onValue
  //       .listen((DatabaseEvent event) {
  //     messageList.clear();
  //     final data = event.snapshot.value as Map<dynamic, dynamic>;
  //     for (var userMap in data.values) {
  //       MessageModel model = MessageModel.fromMap(userMap);
  //       messageList.add(model);
  //     }
  //   });
  // }
}
