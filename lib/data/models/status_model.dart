class StatusModel {
  String? statusId,
      userId,
      type,
      caption,
      statusImageUri,
      statusVideoUri,
      userName;
  int? time = 0;
  bool seen = false;

  StatusModel({
    this.statusId,
    this.userId,
    this.type,
    this.statusImageUri,
    this.statusVideoUri,
    this.userName,
    this.caption,
    this.time,
    required this.seen,
  });

  factory StatusModel.fromMap(Map<dynamic, dynamic> map) {
    return StatusModel(
      statusId: map['statusId'],
      seen: map['seen'],
      userId: map['userId'],
      type: map['type'],
      statusImageUri: map['statusImageUri'],
      statusVideoUri: map['statusVideoUri'],
      userName: map['userName'],
      caption: map['caption'],
      time: map['time'],
    );
  }
}
