import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:image_picker/image_picker.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  ConversationScreen(this.chatRoomId, this.userName);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return Container(
      padding: EdgeInsets.only(bottom: 80),
      child: StreamBuilder(
          stream: chatMessagesStream,
          builder: (BuildContext  context, snapshot) {
            return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile (snapshot.data.docs[index].data()["message"], snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
                }): Container();
          }
      ),
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty || messageController.text == null){
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  // Method for selecting a picture from the gallery
  File _image;

  Future getImage() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image as File;
    });
  }

  //upload image to FirebaseStorage
  File _imageFile;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userNameTile(userName: widget.userName ?? 'no name'),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xFF444141),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white,fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Write a message...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // TODO Button add image
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff6495ed),
                            const Color(0xff1e90ff),
                            const Color(0xff00bfff),
                          ]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.image_outlined, color: Colors.white, size: 30,),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff6495ed),
                            const Color(0xff1e90ff),
                            const Color(0xff00bfff),
                          ]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(
                          "assets/image/send_message.png",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 14, right: isSendByMe ? 14 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007ef4),
              const Color(0xff2a75bc),
            ] : [
              const Color(0x1affffff),
              const Color(0x1affffff),
            ],
          ),
          borderRadius: isSendByMe ?
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          ),
        ),
          child: Text(message, style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
    );
  }
}

Widget userNameTile ({String userName}){
  return Text(userName);
}