abstract class UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<Map<String, dynamic>> users;

  UsersLoaded(this.users);
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}
