import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()['name']);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if(val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomsScreen())
          );
        }
      });
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Размер всего поля чтобы можно было маштабировать
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please provide a valid Email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration('Email'),
                      ),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 6
                                ? null
                                : 'Please provide password 6+ character';
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration('Password')),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007ef4),
                            const Color(0xff2a75bc),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Sign In',
                      style: simpleTextFieldStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'Sign In with Google',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don`t have account? ',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Register now',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
