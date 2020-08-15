import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:geolocator/geolocator.dart';

class sharedServices {
  FirestoreClient FirestoreClientInstance;
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;

  static Future getPostalCode() async {
    String pcode = "140001"; // ropar default
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = p[0];
    pcode = place.postalCode;
    print(pcode);
    return pcode;
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
}
