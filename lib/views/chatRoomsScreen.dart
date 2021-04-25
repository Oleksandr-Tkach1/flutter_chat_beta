import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:flutter_chat_beta/views/search.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
import 'massage_screen.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row
            (
            mainAxisAlignment: MainAxisAlignment.end,
            children:
            [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessageScreen()));
              },
              child: Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  "assets/image/send_message.png",
                color: Colors.white,
          ),
              ),
            ),
            ],
          ),
      ),
      body: Text(''),
      drawer: drawerStyle(context),
    );
  }
}