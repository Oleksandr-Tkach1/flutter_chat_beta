import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:uuid/uuid.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Chat', style: TextStyle(fontSize: 25),
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
                padding: EdgeInsets.only(left: 5, top: 31),
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
                height: 45,
                width: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text('${Constants.myName.substring(0, 1).toUpperCase()}', style: TextStyle(color: Colors.white, fontSize: 18),
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

createChatRoomStartConversation({String userName, String userEmail, BuildContext context}) {
  if (userName != Constants.myName) {
    //String chatRoomId = getChatRoomId(userName, Constants.myName);
    var chatRoomId = Uuid().v1();

    //String user = jsonEncode(User(userName, userEmail));
    //String me = jsonEncode(User(Constants.myName, Constants.myEmail));

    //List<User> chatUsers =(json.decode('[{"userName":"Sasha","email":"k@gmail.com"},{"userName":"4ELOVEK","email":"sasha228023@gmail.com"}]') as List).map((i) => User.fromJson(i)).toList();

    //User me;
    //chatUsers.forEach((chatUser) {
    //  if(chatUser.email != Constants.myEmail) {
    //    me = chatUser;
    //  }
   // if(me != null) {
   //   print('Ура я нашел своего юзера' + me.userName);
   // } else {
   //   print('Oy noy ((');
   // }

    //});
    List<String> users = [userEmail, Constants.myEmail];

    Map<String, dynamic> chatRoomMap = {
      'chatName': userName +', '+ Constants.myName,
      'users': users,
      'chatRoomId': chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        chatRoomId,
        userName,
      ),
    ),
    );
  } else {
    print('you cannot send message to yourself');
  }
}

class User {
  String userName;
  String email;

  User(this.userName, this.email);

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {
        'userName': userName,
        'email': email,
      };
}