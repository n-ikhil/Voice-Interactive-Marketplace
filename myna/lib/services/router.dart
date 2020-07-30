import 'package:flutter/material.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/screens/ItemList/ItemList.dart';
import 'package:myna/screens/NewItem/NewItem.dart';
import 'package:myna/screens/ProductList/ProductList.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/screens/credentials/root_page.dart';
import 'package:myna/screens/itemDetail/ItemDetail.dart';
import '../constants/variables/ROUTES.dart';

// https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df

Auth auth = Auth();

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
//        return MaterialPageRoute(builder: () => HomePage());
      case productList:
        return MaterialPageRoute(
            builder: (_) => ProductList(
                  categoryID: settings.arguments,
                ));
      case newItemPage:
        return MaterialPageRoute(builder: (_) => NewItem());
      case itemDetail:
        return MaterialPageRoute(builder: (_) => ItemDetail());
      case itemList:
        return MaterialPageRoute(builder: (_) => ItemList());
      case credentialPage:
        return MaterialPageRoute(builder: (_) => RootPage(auth: auth));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
