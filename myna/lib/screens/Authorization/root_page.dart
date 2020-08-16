import 'package:flutter/material.dart';
import 'package:myna/screens/HomePage/HomePage.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/screens/Authorization/login_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((user) {
      setState(() {
        authStatus =
            user.email != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          title: 'Myna Login',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return HomePage(
          SignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
          auth: widget.auth,
        );
    }
  }
}
