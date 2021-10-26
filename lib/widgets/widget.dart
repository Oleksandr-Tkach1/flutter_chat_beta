import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/authenticate.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/services/storage.dart';
import 'package:flutter_chat_beta/views/conversatoin_screen.dart';
import 'package:flutter_chat_beta/views/settings.dart';
import 'package:image_picker/image_picker.dart';
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

Widget drawerStyle(BuildContext context, String myName) {
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
                  child: Text(
                    Constants.myEmail,
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
                child: Text(myName.substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 23),),
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchList()),
              );
            }),
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

String getFirstChar(String myName) {
  if(myName.length > 0) {
    return myName.substring(0, 1).toUpperCase();
  } else {
    return '';
  }
}

//TODO
createChatRoomStartConversation({String userName, String userEmail, BuildContext context, String inputChatName}) {
  final SecureStorage secureStorage = SecureStorage();
  if (userName != Constants.myName) {
    secureStorage.writeSecureData('userName', userName);
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
      'chatName':  inputChatName != null && inputChatName.isNotEmpty ? inputChatName: (userName +', '+ Constants.myName),
      'users': users,
      'chatRoomId': chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        chatRoomId,
        userName,

        inputChatName != null && inputChatName.isNotEmpty ? inputChatName : (userName +', '+ Constants.myName),
      ),
    ),
    );
  } else {
    print('you cannot send message to yourself');
  }
}

AlertDialog buildNameRequestDialog(BuildContext context, TextEditingController userChatNameTextEditingController, Function onPressed){
  final formKey = GlobalKey<FormState>();
  // chatUserName(){
  //   if(formKey.currentState.validate()){
  //     Navigator.of(context).pop();
  //   }
  // };
  return AlertDialog(
    backgroundColor: Color(0xff282727),
    title: Text('Do you want to rename the chat?', style: TextStyle(color: Colors.white,)),
    content: Container(
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Form(
              key: formKey,
              child: TextFormField(
                validator: (val){
                  return val.isEmpty || val.length > 12 ? 'Please provide a valid Username' : null;
                },
                controller: userChatNameTextEditingController,
                style: simpleTextFieldStyle(),
                decoration: textFieldInputDecoration('Chat name'),
              ),
            ),
            SizedBox(height: 5,),
            Text('If you do not specify the name of the chat, the chat will be named after the username', style: TextStyle(color: Colors.white,)),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Apply'),
        onPressed: () => onPressed(),
      ),
    ],
  );
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

Icon actionIcon = Icon(
  Icons.search,
  color: Colors.white,
);

Widget appBarTitle = Text("Your chats", style: TextStyle(color: Colors.white, fontSize: 25,),);


Widget buildAppbar(Function function) {
  return AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
    IconButton(
      icon: actionIcon,
      onPressed: () {
        function.call();
      },
    ),
  ]);
}



var bodyProgress = Container(
  child: Stack(
    children: <Widget>[
      //body,
       Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(10.0)
          ),
          width: 300.0,
          height: 200.0,
          alignment: AlignmentDirectional.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
