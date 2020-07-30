import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/screens/credentials/primary_button.dart';
import '../../services/firebase/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register, reset }

class _LoginPageState extends State<LoginPage> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';
  bool showErrorMessage = false;
  bool showRecoverPasswordOption = false;
  bool showPasswordField = true;
  String message = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndRequestReset() async {
    if (validateAndSave()) {
      try{
        await widget.auth.resetPassword(_email);
        showErrorMessage = true;
        message = "Check your inbox";
        moveToLogin();
      }
      catch (resetError) {
        setState(() {
          _authHint = 'Sign In/Up Error\n\n${resetError.toString()}';
        });
        if (resetError is PlatformException) {
          setState(() {
            showErrorMessage = true;
            message = resetError.message;
          });
        }
        print(resetError);
      }
    }
    else {
      setState(() {
        _authHint = '';
      });
    }

  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        var user = await FirebaseAuth.instance.currentUser();
        print("verification status : ${user.isEmailVerified}");
        if (user.isEmailVerified) {
          widget.onSignIn();
        } else {
          setState(() {
            showErrorMessage = true;
            message = "Verify Your Email";
          });
        }
      } catch (signUpError) {
        setState(() {
          _authHint = 'Sign In/Up Error\n\n${signUpError.toString()}';
        });
        if (signUpError is PlatformException) {
          setState(() {
            showErrorMessage = true;
            message = signUpError.message;
          });
          if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {}
          if (signUpError.code == 'ERROR_WRONG_PASSWORD') {
            setState(() {
              showRecoverPasswordOption = true;
            });
          } else {
            setState(() {
              showRecoverPasswordOption = false;
            });
          }
        }
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  resetVisibility() {
    setState(() {
      showErrorMessage = false;
      showRecoverPasswordOption = false;
      showPasswordField = true;
    });
  }

  void moveToRegister() {
    formKey.currentState.reset();
    resetVisibility();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    resetVisibility();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  void moveToReset() {
    formKey.currentState.reset();
    resetVisibility();
    setState(() {
      showPasswordField = false;
    });
    setState(() {
      _formType = FormType.reset;
      _authHint = '';
    });
  }

  List<Widget> emailVerificationWidget() {
    print("Hint ERR : $_authHint");
    return [
      Visibility(
        visible: showErrorMessage,
        child: Container(
          height: 40,
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          color: Colors.lightGreen[100],
          child: Text(
            message,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
          ),
        ),
      ),
    ];
  }

  List<Widget> forgetPasswordWidget() {
    return [
      Visibility(
        visible: showRecoverPasswordOption,
        child: FlatButton(
            key: Key('need-account'),
            child: Text(RECOVER_BUTTON_TEXT),
            onPressed: moveToReset),
      ),
    ];
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),
      Visibility(
          visible: showPasswordField,
          child: padded(
              child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            autocorrect: false,
            validator: (val) =>
                val.isEmpty ? 'Password can\'t be empty.' : null,
            onSaved: (val) => _password = val,
          ))),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          PrimaryButton(
              key: Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-account'),
              child: Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
      case FormType.register:
        return [
          PrimaryButton(
              key: Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-login'),
              child: Text("Have an account? Login"),
              onPressed: moveToLogin),
        ];
      case FormType.reset:
        return [
          PrimaryButton(
              key: Key('reset'),
              text: 'Reset Password',
              height: 44.0,
              onPressed: validateAndRequestReset),
          FlatButton(
              key: Key('need-account'),
              child: Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
    }
    return null;
  }

  _launchURL() async {
    const url = 'http://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: usernameAndPassword() +
                                      submitWidgets() +
                                      emailVerificationWidget() +
                                      forgetPasswordWidget(),
                                ))),
                      ])),
                ]))));
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
