import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ChatScreen.dart';
import 'Register.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // FacebookLogin _facebookLogin = FacebookLogin();
  // User _user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Sign in")
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //email
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 23),
                  RaisedButton(
                    padding: EdgeInsets.only(
                        left: 90, right: 90, top: 20, bottom: 20),
                    elevation: 5,
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          var result = await firebaseAuth
                              .signInWithEmailAndPassword(email: emailController
                              .text, password: passController.text);
                          User user = result.user;
                          if (user != null) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChatScreen()));
                          }
                        }
                        catch (e) {
                          print(e.message);
                        }
                      }
                    },
                    child: Text("Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 14),),
                  ),
                  SizedBox(height: 23),
                  RaisedButton(
                    padding: EdgeInsets.only(
                        left: 90, right: 90, top: 20, bottom: 20),
                    elevation: 5,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => Register()));
                    },
                    child: Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  // RaisedButton(
                  //   padding: EdgeInsets.only(left:90,right:90,top:20,bottom: 20),
                  //   elevation: 5,
                  //   color: Colors.blue,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30.0),
                  //   ),
                  //   onPressed: () async{
                  //     await _handleLogin();
                  //     Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => Register()));
                  //   },
                  //   child: Text("Facebook Login",style: TextStyle(color: Colors.white,fontSize: 14)),
                  // ),
                ],
              ),
            ),
          ),
        )
    );
  }

//   Future _handleLogin() async {
//     FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
//     switch(_result.status){
//       case FacebookLoginStatus.cancelledByUser:
//         print('Canceled by user');
//         break;
//       case FacebookLoginStatus.error:
//         print('error');
//         break;
//       case FacebookLoginStatus.loggedIn:
//         await _loginWithFacebook(_result);
//       break;
//     }
//   }
//   Future _loginWithFacebook(FacebookLoginResult _result) async{
//     FacebookAccessToken _accessToken = _result.accessToken;
//     AuthCredential _credential = FacebookAuthProvider.credential(_accessToken.token);
//     var a = await firebaseAuth.signInWithCredential(_credential);
//     setState(() {
//       _user = a.user;
//     });
//   }
// }

}