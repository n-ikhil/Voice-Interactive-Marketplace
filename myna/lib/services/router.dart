import 'package:flutter/material.dart';
import 'package:myna/screens/AudioBuyer/AudioBuyer.dart';
import 'package:myna/screens/AudioSeller/AudioSeller.dart';
import 'package:myna/screens/BuySellRoot/BuySellRoot.dart';
import 'package:myna/screens/CategoryResult/CategoryResult.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/screens/ItemList/ItemList.dart';
import 'package:myna/screens/NewItem/NewItem.dart';
import 'package:myna/screens/SearchPage/SearchPage.dart';
import 'package:myna/screens/Authorization/root_page.dart';
import 'package:myna/screens/UserDetail/UserDetailRegistration.dart';
import 'package:myna/screens/UserDetail/UserDetailShow.dart';
import 'package:myna/screens/chat/chat.dart';
import 'package:myna/screens/chat/chatRoomScreen.dart';
import 'package:myna/screens/chat/conversationSetup.dart';
import 'package:myna/screens/itemDetail/ItemDetail.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:provider/provider.dart';
import 'package:myna/speech/speech.dart';
import '../constants/variables/ROUTES.dart';
import 'firebase/auth.dart';

// https://medium.com/flutter-community/clean-navigation-in-flutter-using-generated-routes-891bd6e000df

BaseAuth auth = Auth();

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case audioBuyer:
        return MaterialPageRoute(builder: (_) => AudioBuyer());
      case audioSeller:
        return MaterialPageRoute(builder: (_) => AudioSeller());
      case buySellRoot:
        return MaterialPageRoute(builder: (_) => BuySellRoot());
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case newItemPage:
        return MaterialPageRoute(
            builder: (_) =>
                Consumer<SharedObjects>(builder: (context, myModel, child) {
                  return NewItem(myModel);
                }));

      case speechPage:
        return MaterialPageRoute(builder: (_) => SpeechTextCon());
      case userDetailFormPage:
        return MaterialPageRoute(
            builder: (_) => userDetailForm(
                  arg: settings.arguments,
                ));
      case userDetailViewPage:
        return MaterialPageRoute(
            builder: (_) =>
                Consumer<SharedObjects>(builder: (context, myModel, child) {
                  return userDetailView(
                    arg: settings.arguments,
                    myModel: myModel,
                  );
                }));
      case itemDetail:
        return MaterialPageRoute(builder: (_) {
          return Consumer<SharedObjects>(builder: (context, myModel, child) {
            return ItemDetail(settings.arguments, myModel);
          });
        });
      case itemList:
        return MaterialPageRoute(builder: (_) {
          return Consumer<SharedObjects>(builder: (context, myModel, child) {
            return ItemList(settings.arguments, myModel);
          });
        });
      case categoryResult:
        return MaterialPageRoute(
            builder: (_) =>
                Consumer<SharedObjects>(builder: (context, myModel, child) {
                  return CategoryResult(
                    category: settings.arguments,
                    myModel: myModel,
                  );
                }));
      case searchPage:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case credentialPage:
        return MaterialPageRoute(builder: (_) => RootPage(auth: auth));
      case chatRoom:
        return MaterialPageRoute(
            builder: (_) =>
                Consumer<SharedObjects>(builder: (context, myModel, child) {
                  return ChatRoom(
                    myModel: myModel,
                  );
                }));
      case conversation:
        Map<String, dynamic> args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                Consumer<SharedObjects>(builder: (context, myModel, child) {
                  String chatRoomId = conversationSetup()
                      .setupDualConversion(args["id"], myModel.currentUser);

                  return Chat(
                    chatRoomId: chatRoomId,
                    myModel: myModel,
                  );
                }));
      // case myItems:
      //   return MaterialPageRoute(builder: (_) => MyItems());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
