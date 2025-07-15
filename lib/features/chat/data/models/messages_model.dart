class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime sendTime;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.sendTime,
  });

  factory MessageModel.formJson(snapshot) {
    return MessageModel(
      id: snapshot['id'],
      senderId: snapshot['senderId'],
      senderName: snapshot['senderName'],
      message: snapshot['message'],
      sendTime: snapshot['sendTime'].toDate(),
    );
  }
}
