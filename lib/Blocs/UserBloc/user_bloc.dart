import 'package:chat_application/Blocs/UserBloc/user_event.dart';
import 'package:chat_application/Blocs/UserBloc/user_state.dart';
import 'package:chat_application/Services/chat/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ChatService chatService;

  UserBloc({required this.chatService}) : super(UserLoading()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final usersStream = chatService.getUsers();
        await emit.forEach<List<Map<String, dynamic>>>(
          usersStream,
          onData: (users) => UsersLoaded(users),
          onError: (error, stackTrace) => UserError(error.toString()),
        );
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
