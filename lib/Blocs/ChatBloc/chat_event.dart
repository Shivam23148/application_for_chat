abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String userId;
  final String otherUserId;

  LoadMessages({required this.userId, required this.otherUserId});
}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String message;

  SendMessage({required this.receiverId, required this.message});
}
