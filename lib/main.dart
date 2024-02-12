import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/firebase_options.dart';
import 'package:whats_app_clone/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/views/pages/homepage.dart';
import 'package:whats_app_clone/views/components/splash_screen.dart';
import 'package:whats_app_clone/views/pages/signIn.dart';
import 'package:whats_app_clone/views/pages/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //return runApp(const MyApp());
  return runApp(
    ChangeNotifierProvider(
      create: (context) => RealtimeViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
      getPages: [
        GetPage(name: "/SignUp", page: () => const SignUp()),
        GetPage(name: "/SignIn", page: () => const SignIn()),
        GetPage(name: "/HomePage", page: () => const HomePage()),
      ],
      routes: {
        "SignUp": (context) => const SignUp(),
        "SignIn": (context) => const SignIn(),
        "HomePage": (context) => const HomePage(),
      },
    );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (_) => RealtimeViewModel(),
    //     ),
    //   ],
    //   child: GetMaterialApp(
    //     home: const SplashScreen(),
    //     getPages: [
    //       GetPage(name: "/SignUp", page: () => const SignUp()),
    //       GetPage(name: "/SignIn", page: () => const SignIn()),
    //       GetPage(name: "/HomePage", page: () => const HomePage()),
    //     ],
    //     routes: {
    //       "SignUp": (context) => const SignUp(),
    //       "SignIn": (context) => const SignIn(),
    //       "HomePage": (context) => const HomePage(),
    //     },
    //   ),
    // );
  }
}


