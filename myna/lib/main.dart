import 'package:myna/screens/home-page.dart';
import 'package:myna/stt2.dart';
import 'package:myna/stt3_port.dart';
import 'package:myna/tts.dart';
import 'package:flutter/material.dart';
import 'signin.dart'; 
import 'login.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: stt3_port(),
      // home: stt2(),
      // home: tts(),
      // home: HomePage(title: 'Google Translate'),
    );
  }
}