import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Размер всего поля чтобы можно было маштабировать
              children: [
                TextField(
                  style: simpleTextFieldStyle(),
                  decoration: textFieldInputDecoration('Email'),
                ),
                TextField(
                    style: simpleTextFieldStyle(),
                  decoration: textFieldInputDecoration('Password')
                  ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                      child: Text('Forgot Password?', style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
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
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text('Sign In', style: simpleTextFieldStyle(),),
                ),
                SizedBox(height: 18),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text('Sign In with Google', style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don`t have account? ', style: TextStyle(fontSize: 17, color: Colors.white)),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Register now', style: TextStyle(fontSize: 17, color: Colors.white, decoration: TextDecoration.underline))),
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
