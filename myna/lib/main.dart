import 'package:flutter/material.dart';
import 'package:myna/services/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Myna", onGenerateRoute: Router.generateRoute);
  }
}
