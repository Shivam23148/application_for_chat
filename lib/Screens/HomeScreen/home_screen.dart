import 'package:chat_application/Blocs/AuthBloc/auth_bloc.dart';
import 'package:chat_application/Blocs/UserBloc/user_bloc.dart';
import 'package:chat_application/Blocs/UserBloc/user_event.dart';
import 'package:chat_application/Blocs/UserBloc/user_state.dart';
import 'package:chat_application/Screens/ChatScreen/chat_screen.dart';
import 'package:chat_application/Screens/LoginScreen/login_screen.dart';
import 'package:chat_application/Services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.authBloc});
  AuthBloc authBloc;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc userBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = UserBloc(chatService: ChatService());
    userBloc.add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "${FirebaseAuth.instance.currentUser!.email}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                widget.authBloc.authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (context, state) {
          print("State of home screen is :${state}");
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            print("List of users : ${state.users}");
            return state.users.length <= 0
                ? Center(
                    child: Text("No User Present"),
                  )
                : ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      if (user['uid'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        print("User passed: ${user}");
                        return SizedBox.shrink();
                      } else {
                        return usersTile(user: user);
                      }
                    },
                  );
          } else if (state is UserError) {
            return Center(child: Text(state.error));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class usersTile extends StatelessWidget {
  const usersTile({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(user['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(otherUserID: user['uid']),
            ),
          );
        },
      ),
    );
  }
}
