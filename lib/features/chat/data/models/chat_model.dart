class ChatModel {
  final String id;
  final bool isGroup;
  final String groupName;
  final String groupImage;
  final List<dynamic> members;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.id,
    required this.isGroup,
    required this.groupName,
    required this.groupImage,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatModel.fromFirestore(snapshot) {
    return ChatModel(
      id: snapshot.id,
      isGroup: snapshot['isGroup'],
      groupName: snapshot['groupName'],
      groupImage: snapshot['groupImage'],
      members: snapshot['members'],
      lastMessage: snapshot['lastMessage'],
      lastMessageTime: snapshot['lastMessageTime'].toDate(),
    );
  }
}
