import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/models/UserDetail.dart';

class userProfileFirestoreClient {
  final Firestore _firestore;
  userProfileFirestoreClient(this._firestore);

  Future<void> updateUserData(UserDetail data) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('user');
    return await userCollection.document(data.EmailId).setData({
      "nickName": data.nickName,
      "userFistName": data.userFistName,
      "userLastName": data.userLastName,
      "address": data.Address,
      "mobileNo": data.mobileNo
    });
  }

  Future storeGetUserDetail(FirebaseUser user) async {
    UserDetail userData;
    await _firestore
        .collection("user")
        .where("category", isEqualTo: user.email)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        userData = UserDetail.fromSnapshot(f);
      });
    }).catchError((onError) {
      print(onError);
      Future.error(onError);
    });
    return userData;
  }
}
