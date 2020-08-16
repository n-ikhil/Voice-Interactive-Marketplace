import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myna/models/UserDetail.dart';

class userProfileFirestoreClient {
  final CollectionReference _firestoreCollection;

  userProfileFirestoreClient(this._firestoreCollection);

  Future<void> updateUserData(UserDetail data) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('user');
    return await userCollection.document(data.userID).setData({
      "uid": data.userID,
      "email": data.emailID,
      "nickName": data.nickName,
      "userFistName": data.userFistName,
      "userLastName": data.userLastName,
      "address": data.address,
      "mobileNo": data.mobileNo
    });
  }

  Future<void> initiateUserData(FirebaseUser user) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('user');

    var loginCredEmail = "NA";
    var loginCredPhone = "NA";

    if (user.email != null) {
      loginCredEmail = user.email;
    } else if (user.phoneNumber != null) {
      loginCredPhone = user.phoneNumber;
    }
    return await userCollection.document(user.uid).get().then((value) => {
          if (value.exists)
            {null}
          else
            {
              userCollection.document(user.uid).setData({
                "uid": user.uid,
                "email": loginCredEmail,
                "nickName": "NA",
                "userFistName": "NA",
                "userLastName": "NA",
                "address": "NA",
                "mobileNo": loginCredPhone
              })
            }
        });
  }

  Future<UserDetail> getUserDetail(FirebaseUser user) async {
    UserDetail userData;
    await _firestoreCollection
        .document(user.uid)
        .get()
        .then((value) => {userData = UserDetail.fromSnapshot(value)});
    return userData;
  }
}
