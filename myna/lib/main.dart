import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/widgetAndThemes/theme.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:myna/services/router.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SharedObjects>(
        create: (_) => SharedObjects(),
        child: MaterialApp(
          theme: myTheme,
          debugShowCheckedModeBanner: false,
          title: APP_NAME,
          onGenerateRoute: Router.generateRoute,
          initialRoute: credentialPage,
        ));
  }
}
