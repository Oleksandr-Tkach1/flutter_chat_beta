import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/views/chatRoomsScreen.dart';
import 'package:flutter_chat_beta/views/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff007ef4),
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      //home: Authenticate(),
      //home: ChatRoomsScreen(),
      home: Search(),
    );
  }
}