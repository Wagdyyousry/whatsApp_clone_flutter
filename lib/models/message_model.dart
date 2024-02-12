class MessageModel {
  String? message,
      messageId,
      senderId,
      receiverId,
      fileUri,
      senderImageUri,
      senderName,
      messageType;
  int? time = 0;
  MessageModel(
      {this.message,
      this.messageId,
      this.senderId,
      this.receiverId,
      this.fileUri,
      this.senderImageUri,
      this.senderName,
      this.messageType,
      this.time});
  factory MessageModel.fromMap(Map<dynamic, dynamic> map) {
    return MessageModel(
      message: map['message'],
      messageId: map['messageId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      fileUri: map['fileUri'],
      senderImageUri: map['senderImageUri'],
      senderName: map['senderName'],
      messageType: map['messageType'],
      time: map['time'],
    );
  }
}
