import 'package:flutter/material.dart';
import 'package:myna/services/firebase/config.dart';
import 'package:myna/services/router.dart';
//import 'models/Firebase.dart';
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
          theme: ThemeData(
            primaryColor: PRIMARY_COLOR,
            buttonColor: BUTTON_COLOR,
            accentColor: ACCENT_COLOR,
            cardColor: CARD_COLOR,
            canvasColor: CANVAS_COLOR,
            // Define the default font family.
            fontFamily: FONT_DEFAULT ,
          ),
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
