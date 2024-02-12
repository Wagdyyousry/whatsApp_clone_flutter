class GroupModel {
  String? groupName, groupId, creatorId, groupImageUri;
  List? groupMembers = [];
  int? time = 0;
  GroupModel(
      {this.groupName,
      this.groupId,
      this.creatorId,
      this.groupImageUri,
      this.time,
      this.groupMembers});
      
  factory GroupModel.fromMap(Map<dynamic, dynamic> map) {
    return GroupModel(
        groupName: map['groupName'],
        groupId: map['groupId'],
        creatorId: map['creatorId'],
        groupImageUri: map['groupImageUri'],
        time: map['time'],
        groupMembers: map['groupMembers']);
  }
}
