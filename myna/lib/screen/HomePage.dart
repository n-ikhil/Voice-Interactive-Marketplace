import 'dart:async';

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';

import 'buyer/buyer_ui.dart';

List<Lang> languages = [
  const Lang('Hindi', 'hi_IN'),
  const Lang('English', 'en_US'),
  const Lang('Kannad', 'kn_IN'),
  const Lang('Marathi', 'mr_IN'),
  const Lang('Bengali', 'bn_IN'),
  const Lang('Telgu', 'te_IN'),
  const Lang('Arabic', 'ar_AE'),
  const Lang('punjabi', 'pa_guru_IN'),
];

class Lang {
  final String name;
  final String code;

  const Lang(this.name, this.code);
}

class Home extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  double screenHeight;
  Position position;
  bool _location = false;
  String _language = "None";
  String _userType = "None";
  bool isChecked = false;
  Lang selectedLang = languages.first;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            loginCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }

  void _selectLangHandler(Lang lang) {
    setState(() => selectedLang = lang);
  }

  List<CheckedPopupMenuItem<Lang>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Lang>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "User Type : ",
                    style: TextStyle(color: Colors.brown, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Default Language : $_language",
                    style: TextStyle(color: Colors.brown, fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "GPS :   ",
                        style: TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      new FloatingActionButton(
                          heroTag: "btn3",
                          child: this._location
                              ? Icon(Icons.gps_fixed,
                                  color: Colors.yellow[900], size: 40)
                              : Icon(Icons.gps_not_fixed,
                                  color: Colors.white, size: 40),
                          onPressed: () async {
                            setState(
                              () {
                                _location = _location ? false : true;
                              },
                            );

                            if (_location == true) {
                              Geolocator geolocator = Geolocator()
                                ..forceAndroidLocationManager = true;
                              GeolocationStatus geolocationStatus =
                                  await geolocator
                                      .checkGeolocationPermissionStatus();
                              // print(geolocationStatus  ==  GeolocationStatus.granted  );
                              if (geolocationStatus ==
                                  GeolocationStatus.granted) {
                                try {
                                  position = await Geolocator()
                                      .getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high);
                                } catch (err) {
                                  print(err);
                                  try {
                                    position = await Geolocator()
                                        .getLastKnownPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);
                                  } catch (err) {
                                    print(err);
                                  }
                                }
                                print(position == null
                                    ? 'Unknown'
                                    : position.latitude.toString() +
                                        ', ' +
                                        position.longitude.toString());
                              } else
                                print(geolocationStatus);
                            }
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Language change :  ",
                        style: TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      new PopupMenuButton<Lang>(
                        onSelected: _selectLangHandler,
                        itemBuilder: (BuildContext context) =>
                            _buildLanguagesWidgets,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Audio Assistance :  ",
                        style: TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      new CustomSwitch(
                        activeColor: Colors.yellow[900],
                        value: isChecked,
                        onChanged: (value) {
                          print("VALUE : $value");
                          setState(() {
                            isChecked = !value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatBoatScreen()),
                      );
                    },
                    child: Text(
                      "NEXT",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            size: 48,
            color: Colors.yellow[900],
          ),
          Text(
            "Myna App",
            style: TextStyle(
              fontSize: 34,
              color: Colors.yellow[600],
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.blue[900],
            ),
          )
        ],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/iitrpr_logo.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }
}
