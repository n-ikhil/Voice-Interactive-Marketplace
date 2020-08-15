import 'package:geolocator/geolocator.dart';

locationService() {
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Placemark place;

  getLastKnowLocation() {
    Position position;
    geolocator
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) => position = value);
    return position;
  }

  setAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      place = p[0];
      _currentAddress =
      "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  setCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      setAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
    return _currentPosition;
  }

  checkLocationPermission() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    return geolocationStatus;
  }
}
