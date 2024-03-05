import 'package:flutter/foundation.dart';
import 'package:whats_app_clone/data/models/group_model.dart';
import 'package:whats_app_clone/data/models/message_model.dart';
import 'package:whats_app_clone/data/models/status_model.dart';
import 'package:whats_app_clone/data/models/user_model.dart';
import 'package:whats_app_clone/data/repository/database_repo.dart';

class RealtimeViewModel extends ChangeNotifier {
  late final RealtimeRepo _userRepository;
  List<UserModel> userList = [];
  List<GroupModel> groupList = [];
  List<List<StatusModel>> allStatusList = [];
  UserModel currentUser = UserModel();

  RealtimeViewModel() {
    _userRepository = RealtimeRepo();
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
