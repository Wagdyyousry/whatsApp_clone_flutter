import 'dart:io';

import 'package:circular_image/circular_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app_clone/models/user_model.dart';
import 'package:whats_app_clone/views/pages/view_image_page.dart';

// ignore: must_be_immutable
class CreateNewGroup extends StatefulWidget {
  UserModel currentUserData = UserModel();
  List<UserModel> usersList = [];
  CreateNewGroup({
    super.key,
    required this.usersList,
    required this.currentUserData,
  });

  @override
  State<CreateNewGroup> createState() => _CreateNewGroup();
}

class _CreateNewGroup extends State<CreateNewGroup> {
  TextEditingController groupName = TextEditingController();
  UserModel currentUser = UserModel();
  List<int> selectedUserIndex = [];
  List<UserModel> userList = [];
  List<String> selectedGroupList = [];
  String? currentUserID;
  File? groupImageUrl;
  @override
  void initState() {
    currentUserID = FirebaseAuth.instance.currentUser!.uid;
    currentUser = widget.currentUserData;
    userList = widget.usersList;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Create Group",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
            IconButton(
              padding: const EdgeInsets.all(20),
              onPressed: () {
                if (selectedGroupList.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "You didn`t choose any one.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(255, 203, 52, 42),
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  showCustomDialog();
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                if (!selectedGroupList.contains(userList[i].userId!)) {
                  selectedGroupList.add(userList[i].userId!);
                  Fluttertoast.showToast(
                      msg: "${userList[i].name} Added to the Group.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  setState(() {
                    selectedUserIndex.add(i);
                  });
                }
              },
              onDoubleTap: () {
                if (selectedGroupList.contains(userList[i].userId!)) {
                  selectedGroupList.remove(userList[i].userId!);
                  Fluttertoast.showToast(
                      msg: "User Removed from the Group.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(255, 203, 52, 42),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  setState(() {
                    selectedUserIndex.remove(i);
                  });
                }
              },
              child: Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 50,
                            width: 50,
                            child: CircularImage(
                                onImageTap: () {
                                  if (currentUser.profileImageUri != null) {
                                    Get.to(()=>ViewImagePage(
                                        image: currentUser.profileImageUri));
                                  }
                                },
                                radius: 50,
                                borderWidth: 1.5,
                                borderColor: Colors.blue,
                                source: 'images/bg3.jpg')),
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
                      ]),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.check_box,
                              color: selectedUserIndex.contains(i)
                                  ? Colors.green
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 17,
          shadowColor: Colors.blue,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Create New Group',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0b6156)),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 120,
                  width: 120,
                  child: CircularImage(
                      badge: const Icon(
                        Icons.add,
                        color: Color(0xFF0b6156),
                      ),
                      badgeBorderColor: Colors.blue,
                      badgeBorderWidth: 1.5,
                      onBadgeTap: () {
                        pickImageFromGallery();
                      },
                      badgeSize: 32,
                      badgePositionBottom: 2,
                      badgePositionRight: 2,
                      radius: 70,
                      borderWidth: 2,
                      borderColor: const Color(0xFF0b6156),
                      source: groupImageUrl != null
                          ? groupImageUrl!.path
                          : 'images/bg1.jpg'),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: groupName,
                    decoration: const InputDecoration(
                      labelText: 'Enter group name',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      labelStyle: TextStyle(
                        color: Color(0xFF0b6156),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancle',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 97, 11, 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          createNewGroup();
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0b6156),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void createNewGroup() {
    if (groupName.text.toString().isEmpty) {
      groupName.text = "Enter Group name";
      return;
    } else {
      selectedGroupList.add(currentUserID!);
      String groupId = DateTime.now().millisecondsSinceEpoch.toString();

      if (groupImageUrl != null) {
        storeGroupImage(groupImageUrl!.path, groupId);
      }
      FirebaseDatabase.instance.ref().child("Groups").child(groupId).set({
        "groupName": groupName.text,
        "groupId": groupId,
        "creatorId": currentUserID,
        "groupImageUri": null,
        "groupMembers": selectedGroupList,
      }).then((value) => {
            Fluttertoast.showToast(
                msg: "Group Created Successfully",
                backgroundColor: Colors.blue,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0),
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false)
          });
    }
  }

  Future pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cropImage(File(pickedFile.path));
    }
  }

  Future cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop The Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      groupImageUrl = File(croppedFile.path);
      setState(() {});
    }
  }

  void storeGroupImage(String resultImageUri, String groupId) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child("groups_profile_images")
        .child(groupId);
    await storageReference.putFile(File(resultImageUri));

    String url = await storageReference.getDownloadURL();

    await FirebaseDatabase.instance
        .ref()
        .child("Groups")
        .child(groupId)
        .update({
      "groupImageUri": url,
    }).then((value) => {
              Fluttertoast.showToast(
                  msg: "Group Image Updated Successfully",
                  backgroundColor: Colors.blue,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  fontSize: 15),
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("HomePage", (route) => false)
            });
  }
}
