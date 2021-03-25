import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/views/search.dart';
class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {

  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your chats',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,))),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child:
                Icon(Icons.exit_to_app,color: Colors.white,size: 24,),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}
