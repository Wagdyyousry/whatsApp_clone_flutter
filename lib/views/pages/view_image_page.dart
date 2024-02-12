import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// ignore: must_be_immutable
class ViewImagePage extends StatefulWidget {
  String? image;
  ViewImagePage({super.key, required this.image});

  @override
  State<ViewImagePage> createState() => _ViewImagePage();
}

class _ViewImagePage extends State<ViewImagePage> {
  String? image;

  @override
  void initState() {
    image = widget.image!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Full Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(image!),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),

      /* SizedBox(
        height: 1200,
        width: 1200,
        child: Image.network(
          image!,
          fit: BoxFit.fitHeight,
        ),
      ), */
    );
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    super.dispose();
  }
}
