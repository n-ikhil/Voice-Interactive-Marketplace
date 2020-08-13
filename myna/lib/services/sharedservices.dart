import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:translator/translator.dart';

class sharedServices {
  FirestoreClient FirestoreClientInstance;
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;

  sharedServices() {
    FirestoreClientInstance = FirestoreClient();
    Auth().currentUser().then((value) => _currentUser = value);
  }


  final translator = GoogleTranslator();

//  local language support

  String _userLanguage = 'en';

  set userLanguage(String value) {
    _userLanguage = value;
  }

  String get userLanguage => _userLanguage;

  Future<Translation> multiLingualText(String inpStr) {
   return translator.translate(inpStr, from: 'en', to: _userLanguage);}
}
