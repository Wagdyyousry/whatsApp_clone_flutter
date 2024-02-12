import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg3.jpg"), fit: BoxFit.cover)),
        child: Form(
          key: formKey,
          child: ListView(
          padding: const EdgeInsets.all(15),
            children: [
              Container(height: 120),
              Image.asset(
                "images/logo.png",
                alignment: Alignment.topCenter,
                height: 150,
                width: 150,
              ),
              Container(height: 35),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("SignUp");
                  },
                  child: const Text("Create New Acount",
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
                    ],
                  ),
                ),
                child: MaterialButton(
                  height: 60,
                  elevation: 10,
                  splashColor: Colors.grey,
                  onPressed: () {
                    userSignIn(emailController.text, passwordController.text);
                  },
                  child: const Text("Sign In",
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
      ),
    );
  }

  Future<void> userSignIn(String userEmail, String userPassword) async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);

        Get.offAllNamed("HomePage");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "No user found for that email.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: "Wrong password provided for that user.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'invalid-credential') {
          // ignore: invalid_return_type_for_catch_error, use_build_context_synchronously
          AwesomeDialog(
            dismissOnTouchOutside: true,
            btnCancelColor: Colors.pink,
            btnOkColor: Colors.blue,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: "Error : Email and password not matching",
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        }
      } catch (e) {
        print("===================|Error : ${e.toString()}");
      }
    } else {}
  }
}

