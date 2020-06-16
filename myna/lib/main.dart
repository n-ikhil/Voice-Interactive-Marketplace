import 'dart:typed_data';
import 'package:feedback/feedback.dart';

//import 'package:myna/extra/google_translator/screen//home-page.dart';
import 'screen/HomePage.dart';
import 'file:///D:/Development_Engineering_Prj/cuddly-umbrella/myna/lib/extra/stt2.dart';
import 'file:///D:/Development_Engineering_Prj/cuddly-umbrella/myna/lib/extra/stt3_port.dart';
import 'extra/translator/screens/home-page.dart';
import 'file:///D:/Development_Engineering_Prj/cuddly-umbrella/myna/lib/model/tts.dart';
import 'package:flutter/material.dart';
import 'screen/signin.dart';

import 'extra/login.dart';
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
//       home: const stt3_port(),
//       home:   SigninPage(),
//      home:   Home(),
//       home: stt2(),
      home: tts(),
//       home: HomePage(title: 'Google Translate'),
      //google translate api do the same work
    );
  }
}
