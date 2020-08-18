import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/services/firebase/FirestoreClients.dart';

class conversationSetup {
  String setupDualConversion(Item peerUser, UserDetail currentUser) {
    getChatRoomId(String a, String b) {
      // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      if (a.compareTo(b) < 0) {
        return "$a\_$b";
      } else {
        return "$b\_$a";
      }
    }

    List<String> users = [peerUser.ownerID, currentUser.userID];
    String chatRoomId = getChatRoomId(peerUser.ownerID, currentUser.userID);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatroomid": chatRoomId,
      "aliasName":
          (currentUser.nickName == null || peerUser.ownerNickName == null)
              ? "Anonymous Chat"
              : currentUser.nickName + " | " + peerUser.ownerNickName
    };

    FirestoreClient().chatRoomClient.addChatRoom(chatRoom, chatRoomId);
    return chatRoomId;
  }
}
