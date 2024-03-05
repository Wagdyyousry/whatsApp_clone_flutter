import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app_clone/data/models/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/bg3.jpg"), fit: BoxFit.cover),
        ),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 120),
            Image.asset(
              "images/logo.png",
              alignment: Alignment.topCenter,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 25),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: Colors.grey,
                filled: true,
                prefixIcon: Icon(Icons.person, color: Colors.black),
                alignLabelWithHint: true,
                label: Text("Enter Your Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: Colors.grey,
                filled: true,
                prefixIcon: Icon(Icons.email, color: Colors.black),
                alignLabelWithHint: true,
                label: Text("Enter Your Email",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(15),
                fillColor: Colors.grey,
                filled: true,
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                alignLabelWithHint: true,
                label: Text("Enter Your Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("SignIn");
                },
                child: const Text("Have an account? Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 1.5,
                    )),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff041F1C),
                        Color(0xff0A534C),
                        Color(0xff05BEAD),
                      ])),
              child: MaterialButton(
                elevation: 10,
                splashColor: Colors.grey,
                height: 60,
                onPressed: () {
                  createNewUser(emailController.text, passwordController.text,
                      nameController.text);
                },
                child: const Text("Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> createNewUser(
      String userEmail, String userPassword, String userName) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword)
          .whenComplete(
            () async => await FirebaseDatabase.instance
                .ref()
                .child("Users")
                .child(FirebaseAuth.instance.currentUser!.uid)
                .set({
                  "name": userName,
                  "email": userEmail,
                  "password": userPassword,
                  "userId": FirebaseAuth.instance.currentUser!.uid
                })
                .whenComplete(
                  () => {
                    AwesomeDialog(
                      dismissOnTouchOutside: true,
                      btnCancelColor: Colors.pink,
                      btnOkColor: Colors.blue,
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Success',
                      desc: 'Created New Acount Succesfully',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {},
                    ).show(),
                    Get.offAllNamed("HomePage")
                  },
                )
                .catchError(
                  (e) => AwesomeDialog(
                    dismissOnTouchOutside: true,
                    btnCancelColor: Colors.pink,
                    btnOkColor: Colors.blue,
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: "Error : ${e.toString()}",
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show(),
                ),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          dismissOnTouchOutside: true,
          btnCancelColor: Colors.pink,
          btnOkColor: Colors.blue,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'The password provided is too weak.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          dismissOnTouchOutside: true,
          btnCancelColor: Colors.pink,
          btnOkColor: Colors.blue,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'The account already exists for that email.',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      } else {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          dismissOnTouchOutside: true,
          btnCancelColor: Colors.pink,
          btnOkColor: Colors.blue,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: "Error : ${e.message}",
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> storeUserData(
      String userEmail, String userPassword, String userName) async {
    try {
      UserModel userModel = UserModel(
          name: userName,
          email: userEmail,
          password: userPassword,
          userId: FirebaseAuth.instance.currentUser!.uid);

      FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .set(userModel);
    } catch (e) {
      print("============${e.toString()}");
    }
  }
}
