import 'dart:typed_data'; 
import 'package:feedback/feedback.dart';
import 'package:myna/screens/home-page.dart';
import 'package:myna/stt2.dart';
import 'package:myna/stt3_port.dart';
import 'package:myna/tts.dart';
import 'package:flutter/material.dart';
import 'signin.dart';  
import './profile_image_upload/home_screen.dart';

import 'login.dart'; 
// void main() {runApp(MyApp()) ;}


void main() {
  runApp(
    BetterFeedback(
      backgroundColor: Colors.grey, 
      drawColors: [Colors.red, Colors.green, Colors.blue, Colors.yellow],
       translation: PunjabiTranslation(),
      child: MyApp(
        key: GlobalKey(debugLabel: 'app_key'),
      ),
      onFeedback: (
        BuildContext context,
        String feedbackText,
        Uint8List feedbackScreenshot,
      ) {
        // upload to server, share whatever
      },
    ),
  );
}
 
class MyApp extends StatelessWidget { 
 const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const stt3_port(),
      // home: stt2(),
      // home: tts(),
       home:  HomeScreen(title: 'Flutter Image picker'),
      // home: HomePage(title: 'Google Translate'), 
      //google translate api do the same work
    );
  }
}
 