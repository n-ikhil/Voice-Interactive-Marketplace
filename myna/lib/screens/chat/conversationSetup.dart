import 'package:myna/constants/variables/common.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';

class conversationSetup {
  String setupDualConversion(String currentUserId) {
    getChatRoomId(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    }

    List<String> users = [Constants.muUid, currentUserId];
    String chatRoomId = getChatRoomId(Constants.muUid, currentUserId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatroomid": chatRoomId,
    };

    FirestoreClient().chatRoomClient.addChatRoom(chatRoom, chatRoomId);
    return chatRoomId;
  }
}
