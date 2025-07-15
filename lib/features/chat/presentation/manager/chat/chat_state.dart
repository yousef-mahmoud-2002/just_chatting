part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChangeChatBackgroundColorState extends ChatState {
  final Color chatBackgroundColor;

  ChangeChatBackgroundColorState({required this.chatBackgroundColor});
}

final class ChangeChatBubbleColorState extends ChatState {
  final Color chatBubbleColor;

  ChangeChatBubbleColorState({required this.chatBubbleColor});
}
