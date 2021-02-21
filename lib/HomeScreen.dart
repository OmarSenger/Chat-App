import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginScreen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser ;

class HomeScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  String _message;
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      // ignore: missing_return
        onMessage: (Map<String, dynamic> message) {
          print('on message: $message');
          displayNotification(message);
        },
        // ignore: missing_return
        onResume: (Map<String, dynamic> message) { // lw mnzl l app t7t
          print('on resume:$message');
        },
        // ignore: missing_return
        onLaunch: (Map<String, dynamic> message) { // lw 2afl l app 5ales
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        }
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((
        IosNotificationSettings settings) {
      print('Settings registered:$settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = _auth.currentUser;
      if (user!=null){
        loggedInUser = user ;
      }
    }  catch (e){
      print(e);
    }
  }

  void _onPressed(){
      setState(() {
        _firestore.collection('messages').add(
            {
              'text':_message,
              'sender':loggedInUser.email,
              "time": DateTime.now()
            });
        _message ='';
        _controller.clear();
      });
  }

  bool isAllSpaces(_message) {
    String output = _message.replaceAll(' ', '');
    if(output == '') {
      return true;
    }
    return false;
  }

  void noThing(){
    print('x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title:Text('Chat'),
          actions : <Widget>[
      GestureDetector(
        onTap: (){
            _auth.signOut();
            Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => LoginScreen()));
        },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Logout',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          )),
    ],
      ),
      body: SafeArea(
       child: Column(
          children : [
         StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('messages').snapshots(),
           // ignore: missing_return
           builder:(context,snapshot){
            if(!snapshot.hasData){
              return Center(
              child: CircularProgressIndicator(),
              );
            }
              final messages = snapshot.data.docs.reversed;
              List<MessageBubble> messageBubbles = [];
              for(var message in messages){
                final messageText = message.data()['text'];
                final messageSender = message.data()['sender'];
                final messageTime = message.data()['time'];
                final currentUser = loggedInUser.email;

                final messageBubble = MessageBubble(text: messageText,sender: messageSender,isMe: currentUser==messageSender,time:messageTime);
                messageBubbles.add(messageBubble);
                messageBubbles.sort((a , b ) => b.time.compareTo(a.time));
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  children:
                  messageBubbles,
                ),
              );
            },
         ),
         Container(
           alignment: Alignment.bottomCenter,
           padding: EdgeInsets.all(5),
           child: Row(
            children: [
            Expanded(
            child:TextField(
            controller: _controller,
            decoration: InputDecoration(
            hintText: 'Type Your Message',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.lightBlueAccent),
            ),
            contentPadding: const EdgeInsets.all(10)
            ),
            minLines: 1,
            maxLines: 10,
            onChanged: (value){
            setState(() {
            _message = value;
            });
            },
            ),
            ),
            SizedBox(
            width: 5,
            ),
            FlatButton(
            onPressed:_controller.text.isEmpty||isAllSpaces(_controller.text)?noThing:_onPressed,
            color: _message == null || _message.isEmpty || isAllSpaces(_message)? Colors.blueGrey : Colors.blue ,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
            ),
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Send',style: TextStyle(color: Colors.white)),
            )),
            ],
            ),
         ),
           ],
       ),
         ),
    );
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload:' + payload);
    }
    await Fluttertoast.showToast(msg: 'Notification Clicked',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16
    );
  }

  void displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['notification']['title'], message['notification']['body'],
        platformChannelSpecifics, payload: 'hello');
  }

  // ignore: missing_return
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
    showDialog(context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child:new Text('Ok'),
            onPressed: ()async{
              Navigator.of(context,rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: 'Notification Clicked',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16
              );
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget{
  final String sender ;
  final String text;
  final bool isMe;
  final Timestamp time;
  MessageBubble({this.text,this.sender,this.isMe,this.time});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,style: TextStyle(fontSize: 12,color: Colors.black),
          ),
          GestureDetector(
            onTap: (){
              Flushbar(
                title: 'Send Time',
                message: '${time.toDate().day}/${time.toDate().month}/${time.toDate().year}  ${time.toDate().hour}:${time.toDate().minute} ${time.toDate().timeZoneName}',
                duration: Duration(seconds: 2),
              ).show(context);
            },
            child: Material(
              borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):
                BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              elevation: 5,
              color: isMe?Colors.lightBlueAccent:Colors.grey,
                child : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text('$text',style: TextStyle(fontSize: 20,color: Colors.white)),
                )
            ),
          ),
        ],
      ),
    );
  }
}