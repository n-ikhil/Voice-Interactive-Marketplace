import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

Future setupFirebase() async {
  return await FirebaseApp.configure(
    name: 'MyProject',
    options: FirebaseOptions(
        googleAppID: Platform.isAndroid
            ? '1:163149270203:android:65ecf64aba59ed47296d9e'
            : 'x:xxxxxxxxxxxxxx:ios:xxxxxxxxxxx',
        apiKey: 'AIzaSyBrS_ho5TUtkMjLCCoISJ8uHrlkZ4Z1tls',
        projectID: 'myna-app',
        gcmSenderID: '163149270203'),
  );
}
