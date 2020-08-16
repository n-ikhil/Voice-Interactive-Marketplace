import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/services/sharedservices.dart';

class mobileLoginHelper {
  final _codeController = TextEditingController();

  SignInSuccess(
      BuildContext context, FirebaseUser user, VoidCallback fun) async {
     // ignore: unawaited_futures
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await registerUserDatabase(context, user);
    Navigator.of(context).pop();
    fun();
  }

  Future<void> registerUserDatabase(
      BuildContext context, FirebaseUser user) async {
    await sharedServices()
        .FirestoreClientInstance
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

    onException(AuthException exception) async {
      //for loading message pop
      Navigator.of(context).pop();

      print("exception code: ${exception.code}");
      print("exception message: ${exception.message}");
       // ignore: unawaited_futures
       showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: CANVAS_COLOR,
              title: Text(
                "LogIn Fail",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "ERR_Code : ${exception.code}",
                    style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Message : ${exception.message}",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("back"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    await _auth.verifyPhoneNumber(
        phoneNumber: _mobileNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          // ignore: unawaited_futures
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            Navigator.of(context).pop();
            SignInSuccess(context, user, _callback);
            print("Done");
          } else {
            print("Error");
          }
        },
        verificationFailed: await onException,
        codeSent: (String verificationId, [int forceResendingToken]) {
//          for loading message pop
          Navigator.of(context).pop();

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
                        autofocus: true,
                        showCursor: true,
                        cursorColor: Colors.green,
                        controller: _codeController,
                      ),
                      Text(
                        "Auto-Detecting",
                        style: TextStyle(fontSize: 15),
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
