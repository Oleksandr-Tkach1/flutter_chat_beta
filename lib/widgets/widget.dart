import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:flutter_chat_beta/views/search.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'Chat',
      style: TextStyle(fontSize: 25),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
}

Widget drawerStyle(BuildContext context) {
  AuthMethods authMethods = new AuthMethods();
  return Drawer(
    child: ListView(
      children: <Widget>[
        Container(
          color: Color(0xff282727),
          child: DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xff6495ed),
                  const Color(0xff1e90ff),
                  const Color(0xff00bfff),
                ]),
              ),
              accountName: Container(
                padding: EdgeInsets.only(left: 5, top: 33),
                alignment: Alignment.bottomLeft,
                child: Text(
                  Constants.myName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              accountEmail: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(Constants.myEmail,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
              ),
              currentAccountPicture: Container(
                margin: EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                            'https://www.zastavki.com/pictures/1920x1200/2011/Animals_Cats_Cat_in_the_glasses_032992_.jpg')
                        .image,
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Color(0xff282727),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 10),
            title: Text(
              "Balance",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: Icon(Icons.monetization_on, color: Colors.white, size: 28),
            // onTap: () {
            // Navigator.of(context).push(
            // MaterialPageRoute(
            // // Временно
            // builder: (context) => AuthorrizationPageState()),
            // );
            // }
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 10),
          title: Text(
            "About myself",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: Icon(Icons.account_box, color: Colors.white, size: 28),
          // onTap: () {
          // Navigator.of(context).push(
          // MaterialPageRoute(
          // builder: (context) => AboutMe()),
          // );
          // }
        ),
        ListTile(
            title: Text(
              "Settings",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: Icon(Icons.settings, color: Colors.white, size: 28),
            contentPadding: EdgeInsets.only(left: 10),
            onTap: () {}),
        ListTile(
          contentPadding: EdgeInsets.only(left: 10),
          title: Text(
            "Exit",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 28,
          ),
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
        ),
      ],
    ),
  );
}

createChatRoomStartConversation({String userName, BuildContext context}) {
  if (userName != Constants.myName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatrooId': chatRoomId
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        chatRoomId,
      ),
    ),
    );
  } else {
    print('you cannot send message to yourself');
  }
}