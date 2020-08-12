import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';

class sharedServices {
  FirestoreClient FirestoreClientInstance;
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;

  sharedServices() {
    FirestoreClientInstance = FirestoreClient();
    Auth().currentUser().then((value) => _currentUser = value);
  }
}
