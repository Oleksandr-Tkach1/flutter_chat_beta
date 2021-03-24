import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUP(){
    if(formKey.currentState.validate()){

    }
  }

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
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ? 'Please Provide UserName' : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration('Username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please Enter Correct Email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration('Email'),
                      ),
                      TextFormField(
                          controller: passwordTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration('Password')
                      ),
                    ],
                  ),
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
                GestureDetector(
                  onTap: (){
                    signMeUP();
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
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text('Sign Up', style: simpleTextFieldStyle(),),
                  ),
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
                  child: Text('Sign Up with Google', style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have account? ', style: TextStyle(fontSize: 17, color: Colors.white)),
                    Text('SignIn now', style: TextStyle(fontSize: 17, color: Colors.white, decoration: TextDecoration.underline)),
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
