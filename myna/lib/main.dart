import 'package:flutter/material.dart';
import 'package:myna/services/router.dart';
import 'models/Firebase.dart';
import './constants/variables/ROUTES.dart';
import './constants/variables/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseCommon firebaseInstance = FirebaseCommon();
  await firebaseInstance.init();
  runApp(MyApp(firebaseInstance));
}

class MyApp extends StatelessWidget {
  final FirebaseCommon firebaseInstance;
  MyApp(this.firebaseInstance) : super();
  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
        firebaseInstance,
        MaterialApp(
          title: APP_NAME,
          onGenerateRoute: Router.generateRoute,
          initialRoute: homePage,
        ));
  }
}

class MyInheritedWidget extends InheritedWidget {
  final FirebaseCommon firebaseInstance;

  MyInheritedWidget(this.firebaseInstance, child) : super(child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return firebaseInstance != old.firebaseInstance;
  }
}
