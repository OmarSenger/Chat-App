import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
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
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,accessToken: googleSignInAuthentication.accessToken);
    UserCredential authResult = await firebaseAuth.signInWithCredential(authCredential);
    User _user = authResult.user;
    return '$_user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Sign in")
      ),
      body: Center(
        child : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                      left: 85, right: 85, top: 15, bottom: 15),
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
                      left: 85, right: 85, top: 15, bottom: 15),
                  elevation: 5,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Register()));
                  },
                  child: Text("Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                SizedBox(height: 20),
                GoogleSignInButton(
              borderRadius: 20.0,
              textStyle: TextStyle(fontSize: 19,color: Colors.black45),
              onPressed: () {
                setState(() async{
                  await signInWithGoogle();
                  Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => ChatScreen()));
                });
              }),
            ],
          ),
          ),
        ),
      ),

    );
  }
}
