import 'package:myna/constants/variables/common.dart';
import 'package:myna/services/sharedservices.dart';

class conversationSetup {
  String setupDualConversion(String currentUserNickName) {
    getChatRoomId(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    }

    List<String> users = [Constants.myName, currentUserNickName];
    String chatRoomId = getChatRoomId(Constants.myName, currentUserNickName);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatroomid": chatRoomId,
    };
    sharedServices()
        .FirestoreClientInstance
        .chatRoomClient
        .addChatRoom(chatRoom, chatRoomId);
    return chatRoomId;
  }
}
