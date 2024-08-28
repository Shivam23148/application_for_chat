import 'package:chat_application/Blocs/ChatBloc/chat_bloc.dart';
import 'package:chat_application/Blocs/ChatBloc/chat_event.dart';
import 'package:chat_application/Blocs/ChatBloc/chat_state.dart';
import 'package:chat_application/Services/chat/chat_service.dart';
import 'package:chat_application/Widget/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.otherUserID});
  String otherUserID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _message = TextEditingController();
  ChatService chatService = ChatService();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        //delay
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    _message.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_message.text.isNotEmpty) {
      await chatService.sendMessagge(widget.otherUserID, _message.text);
      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text("Chat"),
        ),
        body: Column(
          children: [Expanded(child: _messageList()), _userInput()],
        ));
  }

  Widget _messageList() {
    String senderID = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
        stream: chatService.getMessage(widget.otherUserID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Text("No messages yet.");
          }
          return ListView(
            controller: _scrollController,
            children:
                snapshot.data!.docs.map((doc) => _messageItem(doc)).toList(),
          );
        });
  }

  /* Widget _messageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == userID;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color:
                          isCurrentUser ? Colors.green : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(data["messages"]))
            ]));
  }
 */

  Widget _messageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderID'] == FirebaseAuth.instance.currentUser!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    String messageText = data["message"] ?? "No message";

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.green : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(messageText))
        ],
      ),
    );
  }

  Widget _userInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
          hintText: "Type a message.....",
          focusNode: focusNode,
          textEditingController: _message,
        )),
        IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
      ],
    );
  }
}
