import 'package:flutter/material.dart';
import 'package:myna/constants/variables/common.dart';

// rahul dhrub authored
final myTheme = ThemeData(
  primaryColor: PRIMARY_COLOR,
  buttonColor: BUTTON_COLOR,
  accentColor: ACCENT_COLOR,
  cardColor: CARD_COLOR,
  canvasColor: CANVAS_COLOR,
  // fontFamily: FONT_DEFAULT ,
);

// rahul dhrub authored
final darkTheme =  ThemeData(
  primaryColor: Color(0xff145C9E),
  scaffoldBackgroundColor: Color(0xff1F1F1F),
  accentColor: Color(0xff007EF4),
  fontFamily: "OverpassRegular",
  visualDensity: VisualDensity.adaptivePlatformDensity,
);


class CustomColorTheme {
  static Color colorAccent = Color(0xff007EF4);
  static Color textColor = Color(0xff071930);
}
