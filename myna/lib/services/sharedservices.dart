import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:translator/translator.dart';

class sharedServices {
  FirestoreClient FirestoreClientInstance;
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;

  static Future getCurrentLocation() async {
    String pcode = "140001"; // ropar default
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = p[0];
    return place;
  }

  sharedServices() {
    FirestoreClientInstance = FirestoreClient();
    Auth().currentUser().then((value) {
      _currentUser = value;
      print(_currentUser);
      print("nahi");
      return value;
    }).catchError((onError) {
      print("ferk");
      print(onError);
    });
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
