import 'package:chat_application/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //List of User
  Stream<List<Map<String, dynamic>>> getUsers() {
    return firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //Send message
  Future<void> sendMessagge(String recieverId, message) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    final String? currentUserEmail = firebaseAuth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    //create message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail!,
        receiverID: recieverId,
        message: message,
        timestamp: timestamp);

    //chat room id for the two users
    List<String> ids = [currentUserID, recieverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await firebaseFirestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //Get Message

  Stream<QuerySnapshot> getMessage(String userId, otherUserID) {
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return firebaseFirestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
