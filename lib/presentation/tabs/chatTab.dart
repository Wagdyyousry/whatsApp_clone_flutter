import 'package:circular_image/circular_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/data/models/message_model.dart';
import 'package:whats_app_clone/data/models/user_model.dart';
import 'package:whats_app_clone/data/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/presentation/screens/chatting_page.dart';
import 'package:whats_app_clone/presentation/screens/view_image_page.dart';


class ChatTab extends StatefulWidget {
  final List<UserModel> usersList = [];
  final UserModel currentUserData;

  ChatTab({super.key, required this.currentUserData});

  @override
  State<ChatTab> createState() => _ChatTab();
}

class _ChatTab extends State<ChatTab> {
  List<UserModel> userList = [];
  UserModel currentUser = UserModel();
  late DatabaseReference db;
  String lastMessage = '...';

  @override
  void initState() {
    db = FirebaseDatabase.instance.ref('FriendsChats');
    currentUser = widget.currentUserData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.userList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink[700],
              strokeWidth: 3,
            ),
          );
        } else {
          userList = viewModel.userList;
          return ListView.builder(
            itemCount: viewModel.userList.length,
            itemBuilder: (context, i) {
              UserModel currrentUser = userList[i];
              return InkWell(
                onTap: () {
                  Get.to(() => ChattingPage(userModel: currrentUser));
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 50,
                          width: 50,
                          child: CircularImage(
                              onImageTap: () {
                                if (currrentUser.profileImageUri != null) {
                                  Get.to(
                                    () => ViewImagePage(
                                      image: currrentUser.profileImageUri,
                                    ),
                                  );
                                }
                              },
                              radius: 50,
                              borderWidth: 1.5,
                              borderColor: Colors.blue,
                              source: currrentUser.profileImageUri ??
                                  'images/user.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${currrentUser.name}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );

    /* return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Get.to(()=>ChattingPage(userModel: userList[i]));
            },
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 50,
                        width: 50,
                        child: CircularImage(
                            onImageTap: () {
                              if (userList[i].profileImageUri != null) {
                                Get.to(()=>
                                  ViewImagePage(
                                    image: userList[i].profileImageUri,
                                  ),
                                );
                              }
                            },
                            radius: 50,
                            borderWidth: 1.5,
                            borderColor: Colors.blue,
                            source: userList[i].profileImageUri ??
                                'images/bg3.jpg')),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${userList[i].name}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          Text("${userList[i].lastMessage}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center),
                        ]),
                  ],
                ),
              ),
            ),
          );
        }); */
  }

  getUserLastMessage(UserModel receiverUser) {
    if (currentUser.userId != null) {
      final snapshot = db
          .child(currentUser.userId!)
          .child(receiverUser.userId!)
          .orderByChild('time')
          .limitToLast(1)
          .once();
      snapshot.then((value) {
        final data = value.snapshot.value as Map<dynamic, dynamic>;
        for (var messageMap in data.values) {
          MessageModel messageModel = MessageModel.fromMap(messageMap);

          lastMessage = messageModel.message!;
          print("======||${messageModel.message}||");
        }
      });
    }

    // print("======${currentUser.userId}||${receiverUser.userId}||");

    // if (currentUser.userId != null) {
    //   FirebaseDatabase.instance
    //       .ref('FriendsChats')
    //       .child(currentUser.userId!)
    //       .child(receiverUser.userId!)
    //       .orderByChild('time')
    //       .limitToLast(1)
    //       .onValue
    //       .listen(
    //     (DatabaseEvent event) {
    //       print('Inside listen callback');
    //       if (event.snapshot.value != null) {
    //         final data = event.snapshot.value as Map<dynamic, dynamic>;
    //         for (var messageMap in data.values) {
    //           MessageModel messageModel = MessageModel.fromMap(messageMap);

    //           lastMessage = messageModel.message!;

    //           print("======||${messageModel.message}||");
    //         }
    //       }
    //     },
    //   );
    // }
  }
}
