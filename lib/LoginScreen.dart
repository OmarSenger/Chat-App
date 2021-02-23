import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ChatScreen.dart';
import 'Register.dart';
import 'package:firebase_core/firebase_core.dart';

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
                          builder: (BuildContext context) => Register()));
                    },
                    child: Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  SizedBox(height: 23),
                  GoogleSignInButton(
                      borderRadius: 20.0,
                      textStyle: TextStyle(fontSize: 19,color: Colors.black45),
                      onPressed: () {
                        setState(() {
                          signInWithGoogle();
                        });
                      }),
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

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  // void signInWithGoogle() async{
  //   GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  //   AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,accessToken: googleSignInAuthentication.accessToken);
  //   UserCredential authResult = await firebaseAuth.signInWithCredential(authCredential);
  //   User _user = authResult.user;
  //   print(_user);
  // }

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