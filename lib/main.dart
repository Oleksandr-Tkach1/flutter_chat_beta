import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/views/chatRoomsScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Color(0xff282727),
        primaryColor: Color(0xff007ef4),
        scaffoldBackgroundColor: Color(0xff282727),
        primarySwatch: Colors.blue,
      ),
      home:
      userIsLoggedIn == true
          ?
      ChatRoomsScreen()
          :
      Authenticate(),
      //home: ConversationScreen(''),
    );
  }
}