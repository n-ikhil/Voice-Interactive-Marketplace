import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myna/services/textToSpeech.dart';

class CurrentLocation {
  bool isLoaded = false;
  Placemark place;

  CurrentLocation() {
    place = Placemark(
        administrativeArea: "Delhi",
        subAdministrativeArea: "Karol Bagh",
        postalCode: "110001", //delhi
        subLocality: " Ashoka tower ",
        locality: " New Delhi ");
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    place = p[0];
    print("got the final location");
    isLoaded = true;
  }
}

class SharedObjects with ChangeNotifier {
  bool isLoggedIn;
  BaseAuth auth;
  FirestoreClient firestoreClientInstance; // all the client
  UserDetail
      _currentUser; // the current user includes both fire auth and firestore detail
  CurrentLocation currentLocation;

  UserDetail get currentUser => _currentUser;
  String currentLanguage;
  String flutterLanguage;

  SharedObjects() {
    currentLanguage = "en_IN";
    flutterLanguage = "en_IN";
    isLoggedIn = false;
    firestoreClientInstance = FirestoreClient(); //sync
    currentLocation = CurrentLocation();
  }

  void setLanguage(String newLanguge) async {
    print("changin root language");
    this.currentLanguage = newLanguge; //csdcorp standard
    print("changing flutter language");
    this.flutterLanguage =
        await getTtsCompliantLanguageCode(this.currentLanguage);
    print("new flutter language");
    print(flutterLanguage);
    notifyListeners();
  }

  void addAuthInstance(authInst) {
    this.auth = authInst;
  }

  Future updateLoginStatus() async {
    await Auth().currentUser().then((user) async {
      await firestoreClientInstance.userClient
          .getUserDetail(user)
          .then((value) {
        _currentUser = value;
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      print(onError);
    });
    // notifyListeners();
  }
}
