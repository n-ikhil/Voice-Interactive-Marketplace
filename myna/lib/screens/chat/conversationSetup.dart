import 'package:myna/constants/variables/common.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';

class conversationSetup {
  String setupDualConversion(String peerUserId, String currentUserId) {
    getChatRoomId(String a, String b) {
      // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      if (a.compareTo(b) < 0) {
        return "$a\_$b";
      } else {
        return "$b\_$a";
      }
    }

    List<String> users = [peerUserId, currentUserId];
    String chatRoomId = getChatRoomId(peerUserId, currentUserId);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatroomid": chatRoomId,
    };

    FirestoreClient().chatRoomClient.addChatRoom(chatRoom, chatRoomId);
    return chatRoomId;
  }
}
