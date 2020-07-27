import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myna/services/firebase/FirestoreClient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
class FirebaseCommon {
  FirebaseAuth _firebaseAuth;
  FirestoreClient firestoreClient;

  Future init() async {
    FirebaseApp _app = await setupFirebase();
    _firebaseAuth = FirebaseAuth.fromApp(_app);
    firestoreClient = FirestoreClient(Firestore(app: _app));
    await firestoreClient.initConstants();
  }

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
}
