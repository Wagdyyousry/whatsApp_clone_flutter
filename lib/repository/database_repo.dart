import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/models/status_model.dart';
import 'package:whats_app_clone/models/user_model.dart';

class RealtimeRepo {
  String? currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final dbRef = FirebaseDatabase.instance;

  RealtimeRepo() {}

  Future<UserModel> getCurrentUser() async {
    UserModel currentUser = UserModel();
    await FirebaseDatabase.instance
        .ref('Users')
        .child(currentUserID!)
        .onValue
        .listen(
      (DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        UserModel model = UserModel.fromMap(data);
        currentUser = model;
      },
    );
    return currentUser;
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> userList = [];
    await dbRef.ref('Users').onValue.listen(
      (DatabaseEvent event) {
        userList.clear();
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        for (var userMap in data.values) {
          UserModel model = UserModel.fromMap(userMap);
          if (model.userId != currentUserID) {
            userList.add(model);
            //print("uuuuuuuuuuuuu${model.name}");
          }
        }
      },
    );
    return userList;
  }

  Future<List<GroupModel>> getAllGroups() async {
    List<GroupModel> groupList = [];
    await dbRef.ref('Groups').onValue.listen(
      (DatabaseEvent event) {
        groupList.clear();
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        for (var userMap in data.values) {
          GroupModel model = GroupModel.fromMap(userMap);
          if (model.groupMembers!.contains(currentUserID)) {
            groupList.add(model);
          }
        }
      },
    );
    return groupList;
  }

  Future<List<List<StatusModel>>> getAllStatus() async {
    List<List<StatusModel>> allStatusList = [];

    await dbRef.ref('Status').onValue.listen(
      (DatabaseEvent event) {
        allStatusList.clear();
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          for (var userStatus in data.values) {
            List<StatusModel> innerList = [];
            for (var eachStory in userStatus.values) {
              StatusModel model = StatusModel.fromMap(eachStory);
              // print("rrrrrrrrr${model.caption}");
              innerList.add(model);
            }
            allStatusList.add(innerList);
          }
        }
      },
    );
    return allStatusList;
  }

  Future<List<MessageModel>> getUsersMessages(String receiverId) async {
    List<MessageModel> messageList = [];
    await dbRef
        .ref('FriendsChats')
        .child(currentUserID!)
        .child(receiverId)
        .onValue
        .listen((DatabaseEvent event) {
      messageList.clear();
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        for (var userMap in data.values) {
          MessageModel model = MessageModel.fromMap(userMap);
          messageList.add(model);
          //print("========${model.message}");
        }
      }
    });
    return messageList;
  }

  Future<List<MessageModel>> getGroupsMessages(String groupId) async {
    List<MessageModel> messageList = [];
    await dbRef
        .ref('GroupsChats')
        .child(groupId)
        .orderByChild('time')
        .onValue
        .listen(
      (DatabaseEvent event) {
        messageList.clear();
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          for (var userMap in data.values) {
            MessageModel model = MessageModel.fromMap(userMap);
            messageList.add(model);
            //print("++++++${model.message}");
          }
        }
      },
    );
    return messageList;
  }
}


/*  Future<List<MessageModel>> getUsersMessages(String receiverId) async {
    List<MessageModel> messageList = [];
    DataSnapshot dataSnapshot = (await dbRef
        .ref('FriendsChats')
        .child(currentUserID!)
        .child(receiverId)
        .once()) as DataSnapshot; // Use 'once' instead of 'onValue'

    final data = dataSnapshot.value as Map<String, dynamic>;
    for (var userMap in data.values) {
      MessageModel model = MessageModel.fromMap(userMap);
      messageList.add(model);
      print("=====${model.message}");
    }

    return messageList;
  } */
