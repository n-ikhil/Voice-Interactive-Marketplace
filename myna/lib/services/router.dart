import 'package:flutter/material.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/screens/Search/Search.dart';
import '../constants/variables/ROUTES.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case searchPage:
        return MaterialPageRoute(builder: (_) => SearchPage());
      // case loginPage:
      //   return MaterialPageRoute(builder: (_) => );
      // case registerPage:
      //   return MaterialPageRoute(builder: (_) => Feed());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
