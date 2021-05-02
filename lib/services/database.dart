import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_beta/helper/constants.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

   createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String userEmail) async {
    print(userEmail);
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userEmail)
        .snapshots();
  }

  getChatRoomByUserEmail(String userEmail) async {
    print(userEmail);
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContainsAny: [userEmail, Constants.myEmail]).get();
  }

  // TODO collection (Fit) documents (userPosts, likePost)
  addImageAndComment(messagePostMap) {
    FirebaseFirestore.instance
        .collection('Fit')
        .add(messagePostMap)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    //     .catchError((e) {
    //   print(e.toString());
    // });
  }

  getImageAndComment() async {
    return await FirebaseFirestore.instance
        .collection('Fit')
        .orderBy('time', descending: true)
        .snapshots();
    //     .catchError((e) {
    //   print(e.toString());
    // });
  }

  uploadLike(likePost) async {
    FirebaseFirestore.instance
        .collection('Fit')
        .add(likePost);
  }

  getLike() async {
    return await FirebaseFirestore.instance
        .collection('Fit')
        .snapshots();
  }
}