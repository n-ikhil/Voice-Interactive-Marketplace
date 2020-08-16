import 'package:flutter/material.dart';
import 'package:myna/screens/CategoryResult/CategoryResult.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/screens/ItemList/ItemList.dart';
import 'package:myna/screens/NewItem/NewItem.dart';
import 'package:myna/screens/SearchPage/SearchPage.dart';
import 'package:myna/screens/Authorization/root_page.dart';
import 'package:myna/screens/UserDetail/UserDetailRegistration.dart';
import 'package:myna/screens/UserDetail/UserDetailShow.dart';
import 'package:myna/screens/chat/chatRoomScreen.dart';
import 'package:myna/screens/itemDetail/ItemDetail.dart';
import 'package:myna/speech/speech.dart';
import '../constants/variables/ROUTES.dart';
import 'firebase/auth.dart';

// https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df

BaseAuth auth = Auth();

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case newItemPage:
        return MaterialPageRoute(builder: (_) => NewItem());
      case speechPage:
        return MaterialPageRoute(builder: (_) => SpeechTextCon());
      case userDetailFormPage:
        return MaterialPageRoute(
            builder: (_) => userDetailForm(
                  arg: settings.arguments,
                ));
      case userDetailViewPage:
        return MaterialPageRoute(
            builder: (_) => userDetailView(
                  arg: settings.arguments,
                ));
      case itemDetail:
        return MaterialPageRoute(
            builder: (_) => ItemDetail(settings.arguments));
      case itemList:
        return MaterialPageRoute(builder: (_) {
          return ItemList(settings.arguments);
        });
      case categoryResult:
        return MaterialPageRoute(
            builder: (_) => CategoryResult(settings.arguments));
      case searchPage:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case credentialPage:
        return MaterialPageRoute(builder: (_) => RootPage(auth: auth));
      case chatRoom:
        return MaterialPageRoute(builder: (_) => ChatRoom());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
