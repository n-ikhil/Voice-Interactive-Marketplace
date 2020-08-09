import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();

  Future<FirebaseUser> signIn(String email, String password);

  Future<String> createUser(String email, String password);

  Future<void> signOut();

  Future<String> getImageUrl();

  Future<FirebaseUser> handleSignIn();

  Future<String> currentUserEmail();

  Future<void> resetPassword(String email);

  FirebaseAuth getFirebaseAuth();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isUserSignedIn = false;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<FirebaseUser> handleSignIn() async {
    FirebaseUser user;
    bool userSignedIn = await _googleSignIn.isSignedIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = (await _firebaseAuth.signInWithCredential(credential)).user;
    userSignedIn = await _googleSignIn.isSignedIn();

    return user;
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    try {
      await user.sendEmailVerification();
      return user.email;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      return null;
    }
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getImageUrl() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.photoUrl : null;
  }

  Future<void> signOut() async {
    print("Logged Out");
    var ret;
    try {
      ret = await _googleSignIn.signOut();
    } catch (e) {
      print("Not using google signout !");
    }
    ;
    try {
      ret = _firebaseAuth.signOut();
    } catch (e) {
      print(" using google signout !");
    }
    ;
    return ret;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> currentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }
}
