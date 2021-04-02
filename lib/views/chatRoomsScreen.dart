import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:flutter_chat_beta/views/search.dart';
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
                return ChatRoomTile (snapshot.data.docs[index].data()["chatrooId"]
                    //Для показа (изменение имени)
                    .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index].data()["chatrooId"],
                );
              }) : Container();
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
    databaseMethods.getChatRooms(Constants.myName).then((value){
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
          padding: EdgeInsets.only(right: 15),
          child: Center(
              child: Text('Your chats',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold,)
              ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child:
                Icon(Icons.exit_to_app,color: Colors.white,size: 26),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
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
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
        ));
      },
      child: Container(
        //color: Colors.black,
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