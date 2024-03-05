import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:whats_app_clone/data/models/user_model.dart';

class EditStory extends StatefulWidget {
  final File storyImageUrl;
  final UserModel currentUserData;

  const EditStory({
    super.key,
    required this.storyImageUrl,
    required this.currentUserData,
  });

  @override
  State<EditStory> createState() => _EditStory();
}

class _EditStory extends State<EditStory> {
  File? baseStoryImageUrl;
  String? currentUserID;
  late final FirebaseStorage storageRef;
  late final FirebaseDatabase dbRef;
  // UploadTask? _uploadTask;
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    currentUserID = widget.currentUserData.userId!;
    baseStoryImageUrl = widget.storyImageUrl;
    storageRef = FirebaseStorage.instance;
    dbRef = FirebaseDatabase.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white54),
        title: const Text(
          "Edit Story",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            onPressed: () {
              cropImage(baseStoryImageUrl!);
            },
            icon: const Icon(
              Icons.crop,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          baseStoryImageUrl != null
              ? Expanded(
                  child: Image.file(baseStoryImageUrl!, fit: BoxFit.contain),
                )
              : Expanded(
                  child: Image.asset("images/bg4.png", fit: BoxFit.contain),
                ),
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white60),
                    controller: captionController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white54),
                      hintText: 'Type your caption.....',
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    //shape: const StadiumBorder(side: BorderSide(width: 1.0, color: Colors.white)),
                    splashColor: Colors.grey,
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            alignment: Alignment.center,
                            title: Text("Loading the story ..."),
                            content: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.pink[700],
                                    strokeWidth: 3,
                                  ),
                                ],
                              ),
                            ),
                          ); // Show the upload button
                        },
                      );

                      await uploadStatusImage(baseStoryImageUrl!);
                    },
                    backgroundColor: Colors.white70,
                    child: const Icon(
                      shadows: [],
                      Icons.send,
                      color: Colors.black,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> cropImage(File imageFile) async {
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
      baseStoryImageUrl = File(croppedFile.path);
      setState(() {});
    }
  }

  Future<void> uploadStatusImage(File imageFile) async {
    try {
      final ref = await storageRef
          .ref()
          .child("status_images")
          .child(currentUserID!)
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await ref.putFile(imageFile);

      String url = await ref.getDownloadURL();

      await putUrlIntoDatabase(url);
    } catch (e) {}
    ///////////////////////////////////////////
    /* try {
      final ref = storageRef
          .ref()
          .child("status_images")
          .child(currentUserID!)
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(imageFile);

      StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          double progress = 0.0;
          if (snapshot.hasData) {
            var taskSnapshot = snapshot.data!;
            progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          }
          
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Loading the story ..."),
            content: SizedBox(
              child: Column(
                children: [
                  LinearProgressIndicator(value: progress),
                  Text('${(progress * 100).toStringAsFixed(2)}%'),
                ],
              ),
            ),
          );
        },
      );
      await uploadTask.then((p0) => {
            putUrlIntoDatabase(ref.getDownloadURL().toString()),
          });
    } catch (e) {
      print("Error : $e");
    } */
  }

  Future<void> putUrlIntoDatabase(String imageFileURL) async {
    String caption = captionController.text.toString();
    captionController.text = "";

    await dbRef.ref().child("Status").child(currentUserID!).push().set(
      {
        "statusId": currentUserID!,
        "userId": currentUserID!,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "image",
        "seen": false,
        "caption": caption,
        "userName": widget.currentUserData.name!,
        "statusImageUri": imageFileURL,
        "statusVideoUri": ""
      },
    ).then(
      (value) => {
        Fluttertoast.showToast(
            msg: "Status successfully uploaded",
            backgroundColor: Colors.blue,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            fontSize: 15),
        Navigator.of(context)
            .pushNamedAndRemoveUntil("HomePage", (route) => false)
      },
    );
  }
}
