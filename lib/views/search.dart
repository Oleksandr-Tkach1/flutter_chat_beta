import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
import 'chatRoomsScreen.dart';
import 'conversatoin_screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null && searchSnapshot.size > 0
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 392.7,
            ),
            child: ListView.builder(
                itemCount: searchSnapshot.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SearchedItemTile(
                    userName: searchSnapshot.docs[index].data()["name"],
                    userEmail: searchSnapshot.docs[index].data()["email"],
                  );
                }),
          )
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomStartConversation({String userName}) {
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

  Widget SearchedItemTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextFieldStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextFieldStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              'Adding a chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChatRoomsScreen()),
              );
            }),
      ),
      body: Container(
        //TODO
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0x36ffffff),
                          const Color(0x0fffffff),
                        ]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Image.asset(
                        "assets/image/search_icon.png",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
