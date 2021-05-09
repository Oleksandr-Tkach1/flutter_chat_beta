import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_beta/helper/helperfunctions.dart';
import 'package:flutter_chat_beta/services/auth.dart';
import 'package:flutter_chat_beta/services/database.dart';
import 'package:flutter_chat_beta/views/chatRoomsScreen.dart';
import 'package:flutter_chat_beta/widgets/widget.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signMeUP(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        'name' : userNameTextEditingController.text,
        'email' : emailTextEditingController.text,
      };

      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        //print('${val.uid}');
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoomsScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Размер всего поля чтобы можно было маштабировать
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          validator: (val){
                            return val.isEmpty || val.length < 2 ? 'Please provide a valid Username' : null;
                          },
                          controller: userNameTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 40, left: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                width: 3.0,
                                color: Colors.blue,
                              ),
                            ),
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please provide a valid Email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextFieldStyle(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 40, left: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                width: 3.0,
                                color: Colors.blue,
                              ),
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 60),
                        child: TextFormField(
                          obscureText: true,
                            validator: (val){
                              return val.length > 6 ? null : 'Please provide password 6+ character';
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextFieldStyle(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 40, left: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                width: 3.0,
                                color: Colors.blue,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text('Already have account? ', style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text('SignIn now', style: TextStyle(fontSize: 17, color: Colors.white, decoration: TextDecoration.underline))),
                    ),
                    SizedBox(height: 88)
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
