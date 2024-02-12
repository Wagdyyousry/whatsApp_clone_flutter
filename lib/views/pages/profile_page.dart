import 'dart:io';
import 'package:circular_image/circular_image.dart';
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
class ProfilePage extends StatefulWidget {
  UserModel currentUserData = UserModel();
  ProfilePage({super.key, required this.currentUserData});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? currentUserID;
  UserModel userModel = UserModel();
  File? currentProfileImageUrl;
  String currentName = "", currentBio = "";
  bool isFieldsEnabled = false;

  @override
  void initState() {
    userModel = widget.currentUserData;
    putDataInFields(userModel);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "My Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            IconButton(
              onPressed: () async {
                if (!isFieldsEnabled) {
                  setState(() {
                    isFieldsEnabled = true;
                  });
                } else {
                  updateUserData();
                  setState(() {
                    isFieldsEnabled = false;
                  });
                }
              },
              icon: Icon(
                isFieldsEnabled ? Icons.check : Icons.edit,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            CircularImage(
                badge: const Icon(Icons.add,
                    color: Color.fromARGB(255, 14, 89, 17)),
                badgeBorderColor: const Color.fromARGB(255, 14, 89, 17),
                badgeBgColor: Colors.white,
                badgeSize: 30,
                radius: 75,
                badgeBorderWidth: 1,
                borderWidth: 3,
                onImageTap: () {
                  if (userModel.profileImageUri != null) {
                    Get.to(()=>ViewImagePage(image: userModel.profileImageUri));
                  }
                },
                onBadgeTap: () {
                  pickImageFromGallery();
                },
                borderColor: const Color.fromARGB(255, 14, 89, 17),
                source: currentProfileImageUrl != null
                    ? currentProfileImageUrl!.path.toString()
                    : 'images/user.png'),
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(15),
              child: TextField(
                enabled: isFieldsEnabled,
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.blue,width: 10,style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(15),
              child: TextField(
                enabled: isFieldsEnabled,
                controller: bioController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.blue,width: 10,style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            /* const SizedBox(height: 25),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff041F1C),
                      Color(0xff0A534C),
                      Color(0xff05BEAD),
                    ],
                  ),
              ),
              height: 60,width: 120,
              child: MaterialButton(
                onPressed:(){},
                elevation: 5,
                child: const Text("Update",style: TextStyle(color: Colors.white,),),
              ),
            )
           */
          ],
        ),
      ),
    );
  }

  void putDataInFields(UserModel userModel) {
    if (userModel.bio != null) {
      bioController.text = userModel.bio!;
      currentBio = userModel.bio!;
    }
    if (userModel.name != null) {
      nameController.text = userModel.name!;
      currentName = userModel.name!;
    }
    if (userModel.userId != null) {
      currentUserID = userModel.userId.toString();
    }
    if (userModel.profileImageUri != null) {
      currentProfileImageUrl = File(userModel.profileImageUri!);
    }
  }

  Future pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      currentProfileImageUrl = File(pickedFile.path);
      setState(() {});
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
      setState(() {
        currentProfileImageUrl = File(croppedFile.path);
      });

      //updateImage(profileImageUrl!);
    }
  }

  Future updateImage(File imageFile) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child("profile_images")
        .child(currentUserID!);
    await storageReference.putFile(imageFile);

    String url = await storageReference.getDownloadURL();

    await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(currentUserID!)
        .update({
      "profileImageUri": url,
    }).then((value) => {
              Fluttertoast.showToast(
                  msg: "Profile Image Updated successfully",
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

  Future updateUserData() async {
    String newName = nameController.text.toString();
    String newBio = bioController.text.toString();

    final dbRef =
        FirebaseDatabase.instance.ref('Users').child(userModel.userId!);
    if (newName != currentName) {
      await dbRef.update({"name": newName});

      Fluttertoast.showToast(
          msg: "Name Changed Successfully",
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
    if (newBio != currentBio) {
      await dbRef.update({"bio": newBio});
      Fluttertoast.showToast(
          msg: "Bio Changed Successfully",
          fontSize: 18,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);
  }
}
