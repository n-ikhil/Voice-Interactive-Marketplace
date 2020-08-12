import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/widgetAndThemes/theme.dart';
import 'package:myna/services/firebase/config.dart';
import 'package:myna/services/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super();
  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
        MaterialApp(
          theme: myTheme,
          title: APP_NAME,
          onGenerateRoute: Router.generateRoute,
          initialRoute: credentialPage,
        ));
  }
}

class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget( child) : super(child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return false;
  }
}
