import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/widgetAndThemes/theme.dart';
import 'package:myna/services/router.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      onGenerateRoute: Router.generateRoute,
      initialRoute: credentialPage,
    );
  }
}
