import 'package:cloud_firestore/cloud_firestore.dart';

class chatFirestoreClient {
  final CollectionReference _chatFirestoreCollection;
  final CollectionReference _userFirestoreCollection;

  chatFirestoreClient(
      this._chatFirestoreCollection, this._userFirestoreCollection);

  searchByName(String searchField) async {
    return await _userFirestoreCollection
        .where('nickName', isEqualTo: searchField)
        .getDocuments();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    _chatFirestoreCollection
        .document(chatRoomId)
        .setData(chatRoom, merge: true)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return _chatFirestoreCollection
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  // ignore: missing_return
  Future<void> addMessage(String chatRoomId, chatMessageData) {
    _chatFirestoreCollection
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await _chatFirestoreCollection
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
