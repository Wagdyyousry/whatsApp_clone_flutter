import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    Timer(
      const Duration(seconds: 4), // Adjust the duration as needed
      () {
        Get.offNamed(
          currentUser != null ? "HomePage" : "SignUp",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/bg3.jpg"),
        fit: BoxFit.cover,
      )),
      child: SizedBox(
        child: Center(
          child: Image.asset(
            "images/ic_whatsApp.png",
            height: 140,
            width: 140,
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  //   super.dispose();
  // }
}
