import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation {
  bool isLoaded = false;
  Placemark place;

  CurrentLocation() {
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    place = p[0];
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

  SharedObjects() {
    isLoggedIn = false;
    firestoreClientInstance = FirestoreClient(); //sync
    currentLocation = CurrentLocation();
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
