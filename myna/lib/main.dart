 
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myna APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: stt2(), 
      home: stt3_port(), 
      // home: tts(), 
    );
  }
}