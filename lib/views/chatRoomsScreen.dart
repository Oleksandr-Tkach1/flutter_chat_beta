import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/constants.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/services/storage.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'massage_screen.dart';
import 'package:path/path.dart';

class ChatRoomsScreen extends StatefulWidget {

  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {

  TextEditingController userPostComment = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  DatabaseMethods databaseMethods = DatabaseMethods();
  String drawerName = '';
  Stream chatPostStream;
  int like;

  sendMessageCameraAndGallery(File imageFile, BuildContext context) async {
    var imageUrl;
    if(_imageFile != null) {
      imageUrl = await uploadImageToFirebaseGallery(context);
    }
      Map<String, dynamic> messagePostMap = {
        'user': Constants.myName,
        'imageUrl': imageUrl, //test
        'comment': userPostComment.text,
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
        'likesCount': 0,
      };
      databaseMethods.addImageAndComment(messagePostMap);
    userPostComment.text = "";
  }


  //  sendLikePost() async{
  //   Map<String, dynamic> likePost = {
  //     'likePost': like,
  //   };
  //   databaseMethods.uploadLike(likePost);
  //
  //   databaseMethods.getLike().then((value){
  //     setState(() {
  //       chatPostStream = value;
  //     });
  //   });
  // }


  Widget postList() {
    return chatPostStream != null ? Container(
      //padding: EdgeInsets.only(bottom: 20),
      child: StreamBuilder(
          stream: chatPostStream,
          builder: (BuildContext  context, snapshot) {
            return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print('DEBUG DATA: ' + snapshot.data.docs[index].id);
                  return UserFit (
                    snapshot.data.docs[index].data()["user"],
                      snapshot.data.docs[index].id,
                      snapshot.data.docs[index].data()["imageUrl"],
                      snapshot.data.docs[index].data()["comment"],
                    snapshot.data.docs[index].data()["likesCount"],
                  );
                }): Container();
          }
      ),
    ): Container(color: Colors.red,);
  }

  @override
  void initState() {
    databaseMethods.getImageAndComment().then((value){
      setState(() {
        chatPostStream = value;
      });
    });
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {
      drawerName = Constants.myName;
    });
  }

  @override
  Widget build(BuildContext globalContext) {
    return Scaffold(
      appBar: AppBar(
          title: Row
            (
            mainAxisAlignment: MainAxisAlignment.end,
            children:
            [
            GestureDetector(
              onTap: () {
                Navigator.push(globalContext,
                    MaterialPageRoute(builder: (context) => MessageScreen()));
              },
              child: Container(
                height: 30,
                width: 30,
                child: Image.asset("assets/image/send_message.png", color: Colors.white),
              ),
            ),
            ],
          ),
      ),
      body: postList(),
      drawer: drawerStyle(globalContext, drawerName),
        floatingActionButton: GestureDetector(
          child: Container(
            width: 55,
            height: 55,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xff6495ed),
                const Color(0xff1e90ff),
                const Color(0xff00bfff),
              ]),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
              size: 32,
            ),
          ),
          onTap: () {
            //TODO
            //Function onPressed = onApplyButtonClick1(globalContext);
            showDialog(
                context: globalContext,
                builder: (BuildContext context){
                  return buildGalleryOrCameraDialog(
                      globalContext,
                      userPostComment,
                      //onPressed
                  );
                }
            );
          },
        )
    );
  }

  File _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

// upload image to FirebaseStorage
  Future<String> uploadImageToFirebaseGallery(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef = await FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot.ref.getDownloadURL();
  }

  // TODO PhotoCamera

  Future pickImagePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

// upload image to FirebaseStorage
  Future<String> uploadImageToFirebasePhoto(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef = await FirebaseStorage.instance.ref().child('Camera/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot.ref.getDownloadURL();
  }


  AlertDialog buildGalleryOrCameraDialog(BuildContext context, TextEditingController userPostComment,
      //Function onPressed
      ) {
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      backgroundColor: Color(0xff282727),
      title: Text('Choose how you want to add a photo?', style: TextStyle(color: Colors.white,)),
      content: Container(
        child: SingleChildScrollView(
          child: Row(
            children: <Widget>[
              SizedBox(width: 25),
              GestureDetector(
                onTap: (){
                  pickImagePhoto();
                },
                child: Container(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.add_a_photo, color: Colors.white, size: 32,),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff6495ed),
                      const Color(0xff1e90ff),
                      const Color(0xff00bfff),
                    ]),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              SizedBox(width: 85),
              GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: Container(
                  width: 70,
                  height: 70,
                  child: Icon(Icons.image, color: Colors.white, size: 32,),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff6495ed),
                      const Color(0xff1e90ff),
                      const Color(0xff00bfff),
                    ]),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Container(
              height: 55,
              constraints: BoxConstraints(maxWidth: 170),
              child: Form(
                key: formKey,
                child: TextFormField(
                  maxLines: 2,
                  validator: (val) {
                    return val.isEmpty || val.length > 12
                        ? 'Please provide a valid Username'
                        : null;
                  },
                  controller: userPostComment,
                  style: simpleTextFieldStyle(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 30, left: 10),
                    border: OutlineInputBorder(
                      //borderSide: BorderSide(color: Colors.red,),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    hintText: 'Comment',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(width: 55,),
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
                sendMessageCameraAndGallery(_imageFile, context);
                FocusScope.of(context).unfocus();
              }
            ),
          ],
        ),
      ],
    );
  }
}

class UserFit extends StatefulWidget {
  final String user;
  final String id;
  final String imageUrl;
  final String comment;
  final int likesCount;

  UserFit(
      this.user,
      this.id,
      this.imageUrl,
      this.comment,
      this.likesCount,
      );

  @override
  _UserFitState createState() => _UserFitState();
}

class _UserFitState extends State<UserFit> {
  bool _isLiked = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Card(
        color: Color(0xff312e2e),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 70),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 12, bottom: 5),
                        child: Container(
                          height: 44,
                          width: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(widget.user.substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 23),),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        widget.user,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Image.network(widget.imageUrl, width: 375, height: 300, fit: BoxFit.fitWidth,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        child: IconButton(
                          icon: (_isLiked ? Icon(Icons.favorite, size: 30,) : Icon(Icons.favorite_border, size: 30,)),
                          onPressed: addLike,

                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Container(
                          child: Text(widget.likesCount.toString(), style: TextStyle(fontSize: 16, color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 16),
                          constraints: BoxConstraints(maxWidth: 365),
                          child: Text('Comment: ' + widget.comment, style: TextStyle(color: Colors.white, fontSize: 18,),)),
                    ],
                  ),
                  SizedBox(width: 8,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: Text(DateFormat('yyyy-MM-dd    kk:mm').format(now), style: TextStyle(color: Colors.white, fontSize: 12,),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        databaseMethods.addLike(widget.id, widget.likesCount - 1);
      } else {
        _isLiked = true;
        databaseMethods.addLike(widget.id, widget.likesCount + 1);
    }});
  }
}