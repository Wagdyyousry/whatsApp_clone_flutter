import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:whats_app_clone/firebase_options.dart';
import 'package:whats_app_clone/data/viewModels/database_viewModel.dart';
import 'package:whats_app_clone/presentation/screens/homepage.dart';
import 'package:whats_app_clone/presentation/widgets/splash_screen.dart';
import 'package:whats_app_clone/presentation/screens/signIn.dart';
import 'package:whats_app_clone/presentation/screens/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //return runApp(const MyApp());
  runApp(ChangeNotifierProvider(
    create: (context) => RealtimeViewModel(),
    child: MyApp(),
  ));
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays: []);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
