 
import 'package:farmers_mate_mate/stt2.dart';
import 'package:farmers_mate_mate/tts.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: stt2(), 
      // home: tts(), 
    );
  }
}