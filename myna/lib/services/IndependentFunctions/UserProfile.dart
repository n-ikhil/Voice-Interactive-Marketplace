import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/models/UserDetail.dart';
import 'package:myna/services/sharedservices.dart';

class UserProfile {
  Future<UserDetail> fetchUserData(
      BuildContext context, FirebaseUser user) async {
    if (user != null) {
      return await sharedServices()
          .FirestoreClientInstance
          .userClient
          .getUserDetail(user)
          .then((value) => value)
          .catchError((onError) {
        print(onError);
      });
    }
    return null;
  }
}
