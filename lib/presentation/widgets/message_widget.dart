import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final bool isMe;
  final String message;
  final String sendTime;
  const MessageWidget(
      {super.key,
      required this.sendTime,
      required this.isMe,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              sendTime,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}



 
  
 
  /* playAudioFromUrl(String audioUrl) async {
    // Fetch the audio file from the URL
    AudioPlayer audioPlayer = AudioPlayer();
    var response = await Uri.parse(audioUrl));

    if (response.statusCode == 200) {
      // Save the audio file to a temporary file
      String audioPath =
          "temp_audio.mp3"; // You can use a temporary file or a more sophisticated solution
      await File(audioPath).writeAsBytes(response.bodyBytes);

      // Play the audio from the temporary file
      int result = await audioPlayer.play(audioPath, isLocal: true);

      if (result == 1) {
        // success
        print("Audio is playing");
      } else {
        // error
        print("Error playing audio");
      }
    } else {
      // Handle error when fetching the audio file
      print("Failed to fetch audio from the URL");
    }
  }
 */

/* with docs vids and music


import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_app_clone/models/message_model.dart';

class MessageWidget extends StatefulWidget {
  final bool isMe;
  final String message;
  final String type;
  final MessageModel messageModel;
  const MessageWidget({
    super.key,
    required this.isMe,
    required this.message,
    required this.type,
    required this.messageModel,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isMe = false;
  late String message;
  late String type;
  MessageModel messageModel = MessageModel();

  @override
  void initState() {
    isMe = widget.isMe;
    message = widget.message;
    type = widget.type;
    messageModel = widget.messageModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: type == "message"
            ? Text(
                message,
                style: const TextStyle(color: Colors.white),
              )
            : messageType(type),
      ),
    );
  }

  IconButton messageType(String type) {
    switch (type) {
      case "pdf":
        {
          return IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await PDFView(filePath: messageModel.fileUri!);
            },
          );
        }
      case "music":
        {
          return IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () {
              //AudioPlayer().play(Uri.parse(messageModel.fileUri!));
            },
          );
        }
      case "video":
        {
          return IconButton(
            icon: Icon(Icons.video_collection),
            onPressed: () async {
              await launchVideoUrl(messageModel.fileUri!);
              // await VideoPlayerController.file(File(messageModel.fileUri!));
            },
          );
        }
      default:
        {
          return IconButton(
            icon: Icon(Icons.file_present_rounded),
            onPressed: () {},
          );
        }
    }
  }

  launchVideoUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print("Could not launch $url");
    }
  }
 
 
 
  /* playAudioFromUrl(String audioUrl) async {
    // Fetch the audio file from the URL
    AudioPlayer audioPlayer = AudioPlayer();
    var response = await Uri.parse(audioUrl));

    if (response.statusCode == 200) {
      // Save the audio file to a temporary file
      String audioPath =
          "temp_audio.mp3"; // You can use a temporary file or a more sophisticated solution
      await File(audioPath).writeAsBytes(response.bodyBytes);

      // Play the audio from the temporary file
      int result = await audioPlayer.play(audioPath, isLocal: true);

      if (result == 1) {
        // success
        print("Audio is playing");
      } else {
        // error
        print("Error playing audio");
      }
    } else {
      // Handle error when fetching the audio file
      print("Failed to fetch audio from the URL");
    }
  }
 */
}

 */


