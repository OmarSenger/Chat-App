import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';

class inAppMessaging extends StatelessWidget {
  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('In-App Messaging example'),
          ),
          body: Builder(builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                ],
              ),
            );
          }),
        ));
  }
}
//
// class AnalyticsEventExample extends StatelessWidget {
//   Future<void> _sendAnalyticsEvent() async {
//     await inAppMessaging.analytics
//         .logEvent(name: 'awesome_event', parameters: <String, dynamic>{
//       'int': 42, // not required?
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: <Widget>[
//             const Text(
//               "Log an analytics event",
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text("Trigger an analytics event"),
//             const SizedBox(height: 8),
//             RaisedButton(
//               onPressed: () {
//                 _sendAnalyticsEvent();
//                 Scaffold.of(context).showSnackBar(const SnackBar(
//                     content: Text("Firing analytics event: awesome_event")));
//               },
//               color: Colors.blue,
//               child: Text(
//                 "Log event".toUpperCase(),
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }