import 'package:chat_application/Blocs/ChatBloc/chat_event.dart';
import 'package:chat_application/Blocs/ChatBloc/chat_state.dart';
import 'package:chat_application/Models/message_model.dart';
import 'package:chat_application/Services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;

  ChatBloc({required this.chatService}) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        final messagesStream =
            chatService.getMessage(event.userId, event.otherUserId);
        await emit.forEach<QuerySnapshot>(
          messagesStream,
          onData: (snapshot) {
            List<Message> messages = snapshot.docs
                .map((doc) =>
                    Message.fromMap(doc.data() as Map<String, dynamic>))
                .toList();
            print("Chat is :${messages}");
            return ChatLoaded(messages);
          },
          onError: (error, stackTrace) => ChatError(error.toString()),
        );
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        await chatService.sendMessagge(event.receiverId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
