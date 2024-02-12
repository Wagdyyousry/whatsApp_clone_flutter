import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:status_view/status_view.dart';
import 'package:story_view/story_view.dart';
import 'package:whats_app_clone/models/status_model.dart';
import 'package:whats_app_clone/models/user_model.dart';
import 'package:whats_app_clone/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/views/components/edit_story.dart';
import 'package:whats_app_clone/views/components/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class StatusTab extends StatefulWidget {
  List<List<StatusModel>> allStatusList = [];
  List<StatusModel> currentUserStatus = [];
  List<List<StatusModel>> othersUsersStatus = [];
  UserModel currentUserData = UserModel();
  StatusTab(
      {super.key, required this.allStatusList, required this.currentUserData});

  @override
  State<StatusTab> createState() => _StatusTab();
}

class _StatusTab extends State<StatusTab> {
  UserModel currentUserData = UserModel();
  String? currentUserID;
  List<StatusModel> currentUserStatus = [];
  List<List<StatusModel>> otherUsersStatus = [];
  List<List<StatusModel>> allUserStatus = [];
  List<StoryItem> storyItems = [];
  final storyController = StoryController();
  File? storyImageUrl;
  String userLastStatusTime = "";

  @override
  void initState() {
    currentUserData = widget.currentUserData;
    currentUserID = currentUserData.userId!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.allStatusList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pink[700],
              strokeWidth: 3,
            ),
          );
        } else {
          fetchingUsersStatus(viewModel.allStatusList);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await _pickImageFromGallery();
              },
              child: const Icon(Icons.add),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg2.png"), fit: BoxFit.cover),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (currentUserStatus.isNotEmpty) {
                        viewCurrentUserStatus(currentUserStatus);
                      }
                    },
                    child: statusView(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Friends Status",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherUsersStatus.length,
                    itemBuilder: (context, index) {
                      String lastStatusTime = "";
                      if (otherUsersStatus[index].isNotEmpty) {
                        int timestampInMillis = otherUsersStatus[index]
                                [otherUsersStatus[index].length - 1]
                            .time!;
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            timestampInMillis);
                        lastStatusTime = timeago.format(dateTime);
                      }

                      return InkWell(
                        onTap: () {
                          if (otherUsersStatus.isNotEmpty) {
                            viewCurrentUserStatus(otherUsersStatus[index]);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 70,
                              height: 70,
                              child: StatusView(
                                radius: 32,
                                spacing: 15,
                                strokeWidth: 2.5,
                                indexOfSeenStatus: 3,
                                numberOfStatus: otherUsersStatus[index].length,
                                padding: 4,
                                centerImageUrl: otherUsersStatus[index]
                                        .isNotEmpty
                                    ? otherUsersStatus[index]
                                            [otherUsersStatus[index].length - 1]
                                        .statusImageUri!
                                    : "https://picsum.photos/200/300",
                                seenColor: Colors.grey,
                                unSeenColor: Colors.red,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentUserStatus.isNotEmpty
                                        ? "${otherUsersStatus[index][0].userName}"
                                        : "User Name",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 17, 80, 19),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    lastStatusTime,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      storyImageUrl = File(pickedFile.path);
      Get.to(
        () => EditStory(
          storyImageUrl: storyImageUrl,
          currentUserData: currentUserData,
        ),
      );
    }
  }

  void viewCurrentUserStatus(List<StatusModel> statusList) {
    if (statusList.isNotEmpty) {
      storyItems.clear();
      for (var story in statusList) {
        int timestampInMillis = story.time!;
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestampInMillis);
        String lastStatusTime = timeago.format(dateTime);

        storyItems.add(
          StoryItem.pageImage(
            url: story.statusImageUri!,
            controller: storyController,
            caption: story.caption != null
                ? "${story.caption} \n\n\n\n $lastStatusTime"
                : ". \n\n\n\n $lastStatusTime",
            imageFit: BoxFit.contain,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
    Get.to(
      () => StoryScreen(
        storyList: storyItems,
        controller: storyController,
      ),
    );
  }

  Future<void> fetchingUsersStatus(
      List<List<StatusModel>> allUserStatus) async {
    currentUserStatus.clear();
    otherUsersStatus.clear();
    for (int i = 0; i < allUserStatus.length; i++) {
      if (allUserStatus[i][0].userId == currentUserID) {
        for (int j = 0; j < allUserStatus[i].length; j++) {
          currentUserStatus.add(allUserStatus[i][j]);
        }
        // setState(() {
        //   currentUserStatus.sort((a, b) => a.time!.compareTo(b.time!));
        // });
      } else if (allUserStatus[i][0].userId != currentUserID) {
        otherUsersStatus.add(allUserStatus[i]);
        // setState(() {
        //   otherUsersStatus[i].sort((a, b) => a.time!.compareTo(b.time!));
        // });
      }
    }

    if (currentUserStatus.isNotEmpty) {
      int timestampInMillis =
          currentUserStatus[currentUserStatus.length - 1].time!;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(timestampInMillis);
      userLastStatusTime = timeago.format(dateTime);
    }
  }

  Widget statusView() {
    return InkWell(
      onTap: () {
        if (currentUserStatus.isNotEmpty) {
          viewCurrentUserStatus(currentUserStatus);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 70,
            height: 70,
            child: StatusView(
              radius: 32,
              spacing: 15,
              strokeWidth: 2.5,
              indexOfSeenStatus: 0,
              numberOfStatus: currentUserStatus.length,
              padding: 4,
              centerImageUrl: currentUserStatus.isNotEmpty
                  ? "${currentUserStatus[currentUserStatus.length - 1].statusImageUri}"
                  : "images/bg4.png",
              seenColor: Colors.grey,
              unSeenColor: Colors.red,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentUserStatus.isNotEmpty
                      ? "${widget.currentUserData.name}"
                      : "User Name",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 17, 80, 19),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  userLastStatusTime,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
