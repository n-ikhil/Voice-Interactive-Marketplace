import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class mobileLoginHelper {
  final _codeController = TextEditingController();

  SignInSuccess(BuildContext context, FirebaseUser user, VoidCallback fun) {
    registerUserDatabase(context, user);
    fun();
  }

  Future<void> registerUserDatabase(
      BuildContext context, FirebaseUser user) async {
    await context
        .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
        .firebaseInstance
        .firestoreClient
        .userClient
        .initiateUserData(user);
  }

  mobileSignInHandler(context, _mobileNo, _callback, auth) async {
    print("mobileSignIn using $_mobileNo");
    FirebaseAuth _auth;
    try {
      _auth = auth.getFirebaseAuth();
    } catch (e) {
      print("first: $e");
    }

    await _auth.verifyPhoneNumber(
        phoneNumber: _mobileNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            SignInSuccess(context, user, _callback);
            print("Done");
          } else {
            print("Error");
          }
          Navigator.of(context).pop();
        },
        verificationFailed: (AuthException exception) {
          print("exception code: ${exception.code}");
          print("exception message: ${exception.message}");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          SignInSuccess(context, user, _callback);
                          print("Done");
                        } else {
                          print("Error");
                        }
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }
}
