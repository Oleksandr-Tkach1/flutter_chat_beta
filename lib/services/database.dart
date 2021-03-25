import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUser(String username){

  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users').add(userMap);
  }
}