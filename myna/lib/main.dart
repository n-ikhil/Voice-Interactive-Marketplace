import 'package:flutter/material.dart';
import './screens/HomePage/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Myna", initialRoute: '/', routes: {
      '/': (context) => HomePage(),
      // '/resultList': (context) => ResultList(),
      // '/login':(context)=>
      // '/register':()=>
      // '/chats':()=>
      // '/chatThread':()=>
      // '/resultDetail':()=>
      // '/recordMode':()=>
    });
  }
}
