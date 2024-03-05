import 'dart:async';
import 'dart:io';
import 'package:circular_image/circular_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/data/models/message_model.dart';
import 'package:whats_app_clone/data/models/user_model.dart';
import 'package:whats_app_clone/data/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/presentation/screens/view_image_page.dart';
import 'package:whats_app_clone/presentation/widgets/message_widget.dart';

// ignore: must_be_immutable
class ChattingPage extends StatefulWidget {
  UserModel userModel;

  ChattingPage({super.key, required this.userModel});

  @override
  State<ChattingPage> createState() => _ChattingPage();
}

class _ChattingPage extends State<ChattingPage> {
  FirebaseDatabase dbRefrence = FirebaseDatabase.instance;
  Reference storageReference =
      FirebaseStorage.instance.ref().child('UsersMessagesFiles');
  TextEditingController messageController = TextEditingController();
  List<MessageModel> messageList = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late String senderRoom, receiverRoom, receiverId;
  UserModel userModel = UserModel();

  @override
  initState() {
    userModel = widget.userModel;
    senderRoom = currentUserId + userModel.userId.toString();
    receiverRoom = userModel.userId.toString() + currentUserId;
    receiverId = userModel.userId.toString();

    //gettingUsersMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RealtimeViewModel viewModel = context.watch<RealtimeViewModel>();
    gettingUsersMessages(viewModel);
    return Scaffold(
      appBar: appBarWidget(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg2.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<RealtimeViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, i) {
                      final df = DateFormat("dd/MM hh:mm a");
                      final messagetime = DateTime.fromMillisecondsSinceEpoch(
                          messageList[i].time!);
                      final String sendTime = df.format(messagetime);
                      return messageList[i].senderId == currentUserId
                          ? MessageWidget(
                              sendTime: sendTime,
                              isMe: true,
                              message: messageList[i].message!,
                            )
                          : MessageWidget(
                              sendTime: sendTime,
                              isMe: false,
                              message: messageList[i].message!,
                            );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 7),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.file_present),
                  //   onPressed: () {
                  //     //_showBottomSheet(context);
                  //   },
                  // ),
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
                    onPressed: () {
                      sendingMessages();
                    },
                  ),
                ],
              ),
            )
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

      dbRefrence
          .ref('FriendsChats')
          .child(currentUserId)
          .child(receiverId)
          .child(time.toString())
          .set({
        "message": message,
        "messageId": senderRoom,
        "senderId": currentUserId,
        "receiverId": receiverId,
        "time": time,
        "messageType": "message"
      }).then(
        (value) => {
          dbRefrence
              .ref('FriendsChats')
              .child(receiverId)
              .child(currentUserId)
              .child(time.toString())
              .set({
            "message": message,
            "messageId": senderRoom,
            "senderId": currentUserId,
            "receiverId": receiverId,
            "time": time,
            "messageType": "message"
          })
        },
      );
    }
  }

  Future<void> gettingUsersMessages(RealtimeViewModel viewModel) async {
    //RealtimeViewModel viewModel = context.watch<RealtimeViewModel>();
    final newList = await viewModel.getUsersMessages(receiverId);
    if (messageList.isEmpty) {
      messageList = await viewModel.getUsersMessages(receiverId);
    } else if (messageList.length < newList.length) {
      messageList = await viewModel.getUsersMessages(receiverId);
    }

    messageList.sort((a, b) => b.time!.compareTo(a.time!));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBottomSheetItem(context, Icons.image, 'Gallery', _pickImage),
            _buildBottomSheetItem(
                context, Icons.picture_as_pdf, 'PDF', _pickPDF),
            _buildBottomSheetItem(context, Icons.videocam, 'Video', _pickVideo),
            _buildBottomSheetItem(
                context, Icons.music_note, 'Music', _pickMusic),
          ],
        );
      },
    );
  }

  ListTile _buildBottomSheetItem(
    BuildContext context,
    IconData icon,
    String text,
    Function() onPressed,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        onPressed();
      },
    );
  }

  void _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadMessageFile(File(pickedFile.path), 'image');
    }
  }

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'docx']);
    if (result != null && result.files.isNotEmpty) {
      _uploadMessageFile(File(result.files.first.path!), 'pdf');
    }
  }

  void _pickVideo() async {
    final XFile? pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadMessageFile(File(pickedFile.path), 'video');
    }
  }

  void _pickMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['mp3', 'mp4', 'aac']);
    if (result != null && result.files.isNotEmpty) {
      _uploadMessageFile(File(result.files.first.path!), 'music');
    }
  }

  void _uploadMessageFile(File file, String type) async {
    int time = DateTime.now().millisecondsSinceEpoch;

    try {
      UploadTask uploadTask =
          storageReference.child(time.toString()).putFile(file);

      await uploadTask.whenComplete(() => print('File uploaded successfully'));

      String downloadURL =
          await storageReference.child(time.toString()).getDownloadURL();
      if (type == 'image') {
        await _uploadMessageFileUrl(downloadURL, "image", time);
      } else if (type == 'pdf') {
        await _uploadMessageFileUrl(downloadURL, "pdf", time);
      } else if (type == 'music') {
        await _uploadMessageFileUrl(downloadURL, "music", time);
      } else if (type == 'video') {
        await _uploadMessageFileUrl(downloadURL, "video", time);
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> _uploadMessageFileUrl(
      String fileUrl, String type, int time) async {
    await dbRefrence
        .ref('FriendsChats')
        .child(currentUserId)
        .child(receiverId)
        .child(time.toString())
        .set(
      {
        "message": '',
        "messageId": senderRoom,
        "senderId": currentUserId,
        "receiverId": receiverId,
        "fileUri": fileUrl,
        "time": time,
        "messageType": type,
      },
    ).then((value) async {
      await dbRefrence
          .ref('FriendsChats')
          .child(receiverId)
          .child(currentUserId)
          .child(time.toString())
          .set(
        {
          "message": '',
          "messageId": senderRoom,
          "senderId": currentUserId,
          "receiverId": receiverId,
          "fileUri": fileUrl,
          "time": time,
          "messageType": type,
        },
      );
    });
  }

  AppBar appBarWidget() {
    return AppBar(
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
                  if (userModel.profileImageUri != null) {
                    Get.to(
                      () => ViewImagePage(image: userModel.profileImageUri),
                    );
                  }
                },
                radius: 25,
                borderWidth: 1.5,
                borderColor: Colors.blue,
                source: userModel.profileImageUri ?? 'images/bg3.jpg'),
          ),
          Text(
            userModel.name.toString(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
