import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/views/pages/group_chatting.dart';
import 'package:whats_app_clone/views/pages/view_image_page.dart';

// ignore: must_be_immutable
class GroupsTab extends StatefulWidget {
  List<GroupModel> groupsList = [];
  GroupsTab({super.key, required this.groupsList});

  @override
  State<GroupsTab> createState() => _GroupsTab();
}

class _GroupsTab extends State<GroupsTab> {
  List<GroupModel> groupList = [];

  @override
  void initState() {
    //groupList = widget.groupsList;
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
          groupList = viewModel.groupList;
          return ListView.builder(
            itemCount: groupList.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Get.to(() => GroupChatting(groupModel: groupList[i]));
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
                                if (groupList[i].groupImageUri != null) {
                                  Get.to(
                                    () => ViewImagePage(
                                        image: groupList[i].groupImageUri),
                                  );
                                }
                              },
                              radius: 50,
                              borderWidth: 1.5,
                              borderColor: Colors.blue,
                              source: groupList[i].groupImageUri ??
                                  'images/bg3.jpg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${groupList[i].groupName}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text("${groupList[i].groupId}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                ),
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
  }
}
