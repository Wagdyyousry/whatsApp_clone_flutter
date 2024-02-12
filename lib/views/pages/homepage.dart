import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/status_model.dart';
import 'package:whats_app_clone/models/user_model.dart';
import 'package:whats_app_clone/views/pages/create_new_group.dart';
import 'package:whats_app_clone/views/pages/profile_page.dart';
import 'package:whats_app_clone/views/tabs/chatTab.dart';
import 'package:whats_app_clone/views/tabs/groupsTab.dart';
import 'package:whats_app_clone/views/tabs/statusTab.dart';
import 'package:whats_app_clone/views/pages/signIn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String? currentUserID;
  UserModel currentUser = UserModel();
  List<UserModel> userList = [];
  List<GroupModel> groupList = [];
  List<List<StatusModel>> allStatusList = [];
  List<List<StatusModel>> otherUsersStatus = [];
  List<StatusModel> currentUserStatus = [];

  @override
  initState() {
    currentUserID = FirebaseAuth.instance.currentUser!.uid;
    //RealtimeViewModel viewModel = context.watch<RealtimeViewModel>();
    gettingGroups();
    gettingUsers();
    gettingCurrentUser();

    gettingStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF095049),
          actions: [
            PopupMenuButton(
              iconColor: Colors.white,
              color: Colors.grey,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      Get.to(()=>
                        ProfilePage(
                          currentUserData: currentUser,
                        ),
                      );
                    },
                    child: const Text(
                      "My Profile",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 1.5,
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      /* Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                          (route) => false); */
                      Get.offAll(const SignIn());
                      Fluttertoast.showToast(
                          msg: "Signed Out Successfully.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          decorationThickness: 1.5,
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      /* Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateNewGroup(
                              usersList: userList,
                              currentUserData: currentUser),
                        ),
                      ); */
                      Get.to(()=>
                        CreateNewGroup(
                          usersList: userList,
                          currentUserData: currentUser,
                        ),
                      );
                    },
                    child: const Text(
                      "Create New Group",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          decorationThickness: 1.5,
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
          title: const Text(
            "WhatsApp",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.red,
            tabs: [
              Tab(
                child: Text(
                  "Chat",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  "Status",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  "Groups",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg2.png"), fit: BoxFit.cover),
          ),
          padding: const EdgeInsets.all(5),
          child: TabBarView(
            children: [
              ChatTab(usersList: userList),
              StatusTab(
                allStatusList: allStatusList,
                currentUserData: currentUser,
              ),
              GroupsTab(
                groupsList: groupList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> gettingUsers() async {
    FirebaseDatabase.instance.ref('Users').onValue.listen(
      (DatabaseEvent event) {
        userList.clear();
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        for (var userMap in data.values) {
          UserModel model = UserModel.fromMap(userMap);
          if (model.userId != currentUserID) {
            userList.add(model);
          }
        }
        setState(() {});
      },
    );
  }

  Future<void> gettingGroups() async {
    FirebaseDatabase.instance.ref('Groups').onValue.listen(
      (DatabaseEvent event) {
        groupList.clear();
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        for (var userMap in data.values) {
          GroupModel model = GroupModel.fromMap(userMap);
          if (model.groupMembers!.contains(currentUserID)) {
            groupList.add(model);
          }
        }
        setState(() {});
      },
    );
  }

  Future<void> gettingStatus() async {
    FirebaseDatabase.instance.ref('Status').onValue.listen(
      (DatabaseEvent event) {
        allStatusList.clear();
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          for (var userStatus in data.values) {
            List<StatusModel> innerList = [];
            for (var eachStory in userStatus.values) {
              StatusModel model = StatusModel.fromMap(eachStory);
              innerList.add(model);
              setState(() {});
            }
            allStatusList.add(innerList);
          }
          setState(() {});
        }
      },
    );
  
  }

  Future<void> gettingCurrentUser() async {
    FirebaseDatabase.instance
        .ref('Users')
        .child(currentUserID!)
        .onValue
        .listen((DatabaseEvent event) {
      userList.clear();
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      UserModel model = UserModel.fromMap(data);
      currentUser = model;
      setState(() {});
    });
  }


}



