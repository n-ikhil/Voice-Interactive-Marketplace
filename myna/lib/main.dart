import 'package:flutter/material.dart';
import './redux/initialState.dart';
import './redux/AppState.dart';
import './redux/reducer.dart';
import './screens/HomePage/HomePage.dart';
import './screens/ResultList/ResultList.dart';

void main() {
  runApp(MyApp(
    store: store,
    title: "Myna",
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.store, this.title});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: this.store,
        child: MaterialApp(
          title: this.title,
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/resultList': (context) => ResultList(),
          },
        ));
  }
}
