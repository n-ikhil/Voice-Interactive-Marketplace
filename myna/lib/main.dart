import 'package:flutter/material.dart';
import 'package:myna/services/firebase/config.dart';
import 'package:myna/services/router.dart';
import './constants/variables/ROUTES.dart';
import './constants/variables/common.dart';
import './theme.dart';

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
          theme: myTheme,
          title: APP_NAME,
          onGenerateRoute: Router.generateRoute,
          initialRoute: credentialPage,
        ));
  }
}

class MyInheritedWidget extends InheritedWidget {
  final FirebaseCommon firebaseInstance;

  MyInheritedWidget(this.firebaseInstance, child) : super(child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    if (firebaseInstance.firestoreClient.constants !=
        old.firebaseInstance.firestoreClient.constants) return true;
    return false;
  }
}
