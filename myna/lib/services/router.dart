import 'package:flutter/material.dart';
import 'package:myna/screens/CategoryResult/CategoryResult.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/screens/ItemList/ItemList.dart';
import 'package:myna/screens/NewItem/NewItem.dart';
import 'package:myna/screens/SearchPage/SearchPage.dart';
import 'package:myna/screens/itemDetail/ItemDetail.dart';
import '../constants/variables/ROUTES.dart';

// https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case newItemPage:
        return MaterialPageRoute(builder: (_) => NewItem());
      case itemDetail:
        return MaterialPageRoute(builder: (_) => ItemDetail());
      case itemList:
        return MaterialPageRoute(builder: (_) => ItemList());
      case searchPage:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case categoryResult:
        return MaterialPageRoute(
            builder: (_) => CategoryResult(settings.arguments));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
