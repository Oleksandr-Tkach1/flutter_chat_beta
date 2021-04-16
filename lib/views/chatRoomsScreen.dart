import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:flutter_chat_beta/views/search.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';

class ChatRoomsScreen extends StatefulWidget {
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (BuildContext  context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                print('DEBUG DATA: ' + snapshot.data.docs[index].data().toString());
                return ChatRoomTile (
                  snapshot.data.docs[index].data()["chatName"],
                  snapshot.data.docs[index].data()["chatRoomId"],
                  snapshot.data.docs[index].data()["chatName"],
                );
              }) : Center(child: Text('No chats', style: TextStyle(fontSize: 25, color: Colors.white),));
        }
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    databaseMethods.getChatRooms(Constants.myEmail).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(left: 60),
          child: Text('Your chats',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
          ),
        ),
      ),
      body: chatRoomList(),
      drawer: drawerStyle(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white, size: 45,
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String chatName;

  ChatRoomTile(this.userName, this.chatRoomId, this.chatName);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId, userName, chatName),
        ));
      },
      child: Container(
        color: Color(0xff282727),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text('${userName.substring(0, 1).toUpperCase()}', style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}