import 'package:flutter/foundation.dart';
import 'package:whats_app_clone/models/group_model.dart';
import 'package:whats_app_clone/models/message_model.dart';
import 'package:whats_app_clone/models/status_model.dart';
import 'package:whats_app_clone/models/user_model.dart';
import 'package:whats_app_clone/repository/database_repo.dart';

class RealtimeViewModel extends ChangeNotifier {
  final RealtimeRepo _userRepository = RealtimeRepo();
  List<UserModel> userList = [];
  List<GroupModel> groupList = [];
  List<List<StatusModel>> allStatusList = [];
  UserModel currentUser = UserModel();

  RealtimeViewModel() {
    getCurrentUser();
    getAllUsers();
    getAllGroups();
    getAllStatus();
  }

  Future<void> getAllUsers() async {
    userList = await _userRepository.getAllUsers();
    notifyListeners();
  }

  Future<void> getAllGroups() async {
    groupList = await _userRepository.getAllGroups();
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    currentUser = await _userRepository.getCurrentUser();
    notifyListeners();
  }

  Future<void> getAllStatus() async {
    allStatusList = await _userRepository.getAllStatus();
    notifyListeners();
  }

  Future<List<MessageModel>> getUsersMessages(String recieverID) async {
    List<MessageModel> messageList = [];
    messageList = await _userRepository.getUsersMessages(recieverID);
    notifyListeners();
    return messageList;
  }

  Future<List<MessageModel>> getGroupsMessages(String groupID) async {
    List<MessageModel> messageList = [];
    messageList = await _userRepository.getGroupsMessages(groupID);
    notifyListeners();
    return messageList;
  }
}
