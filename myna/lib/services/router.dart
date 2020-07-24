import 'package:flutter/material.dart';
import '../constants/variables/ROUTES.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
   switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => Home());
      case loginPage:
        return MaterialPageRoute(builder: (_) => Feed());
      case registerPage:
        return MaterialPageRoute(builder: (_) => Feed());
  }
}
