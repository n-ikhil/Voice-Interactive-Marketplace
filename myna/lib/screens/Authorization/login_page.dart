import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/components/mobileLoginHelper.dart';
import 'package:myna/screens/Authorization/primary_button.dart';
import 'package:myna/services/firebase/auth.dart';
import 'package:myna/services/router.dart';
import 'package:myna/services/sharedservices.dart';

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
  static final formKeyLogin = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  FirebaseUser currentUser;
  String _email;
  String _password;
  String _mobileNo;
  FormType _formType = FormType.login;
  bool showErrorMessage = false;
  bool showRecoverPasswordOption = false;
  bool showPasswordField = true;
  bool showMobileNumField = false;
  String message = "";

  SignInSuccess(FirebaseUser user) {
    registerUserDatabase(user);
    widget.onSignIn();
  }

  bool validateAndSave() {
    final form = formKeyLogin.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndRequestReset() async {
    if (validateAndSave()) {
      try {
        await widget.auth.resetPassword(_email);
        showErrorMessage = true;
        setState(() {
          message = "Check your inbox";
        });
        moveToLogin();
      } catch (resetError) {
        if (resetError is PlatformException) {
          setState(() {
            showErrorMessage = true;
            message = resetError.message;
          });
        }
        print(resetError);
      }
    } else {}
  }

  Future<void> registerUserDatabase(FirebaseUser user) async {
    await sharedServices()
        .FirestoreClientInstance
        .userClient
        .initiateUserData(user);
  }

  void validateAndSubmit() async {
    setState(() {
      showMobileNumField = false;
    });
    if (validateAndSave()) {
      // ignore: unawaited_futures
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return   Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        FirebaseUser user = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);

        setState(() {
          currentUser = user;
        });

        await registerUserDatabase(currentUser);

        print("verification status : ${currentUser.isEmailVerified}");
        if (currentUser.isEmailVerified) {
          SignInSuccess(currentUser);
        } else {
          setState(() {
            showErrorMessage = true;
            message = "Verify Your Email";
          });
        }
      } catch (signUpError) {
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
      finally{
        //for loading message pop
        Navigator.of(context).pop();
      }
    } else {}
  }

  signInWithGmailOnly() async {

 // ignore: unawaited_futures
 showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return   Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    FirebaseUser user = await auth.handleSignIn();
    setState(() {
      currentUser = user;
    });
    if (currentUser != null) {
      log(currentUser.email);
      print("currentUser.email");
      print(currentUser.email);
      //for loading message pop
      Navigator.of(context).pop();
      SignInSuccess(currentUser);
    }
    else{
      //for loading message pop
      Navigator.of(context).pop();
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
    formKeyLogin.currentState.reset();
    resetVisibility();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKeyLogin.currentState.reset();
    resetVisibility();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToReset() {
    formKeyLogin.currentState.reset();
    resetVisibility();
    setState(() {
      showPasswordField = false;
    });
    setState(() {
      _formType = FormType.reset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
//            resizeToAvoidBottomInset : false,
            appBar: AppBar(
              title: Text(widget.title),
              automaticallyImplyLeading: false,
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
                                    key: formKeyLogin,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() +
                                          submitWidgets() +
                                          emailVerificationWidget() +
                                          forgetPasswordWidget() +
                                          mobileSignIn() +
                                          googleSignIn(),
                                    ))),
                          ])),
                    ])))));
  }

  List<Widget> emailVerificationWidget() {
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
        autofocus: true,
        cursorColor: Colors.green,
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
            cursorColor: Colors.green,
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

  List<Widget> googleSignIn() {
    return [
      SizedBox(
        height: 16,
      ),
      Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xFF1188AA)),
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              print("googleSignIn");
              setState(() {
                showMobileNumField = false;
              });
              signInWithGmailOnly();
            },
            child: Text(
              "Sign In with Google",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    ];
  }

  List<Widget> mobileSignIn() {
    return [
      SizedBox(
        height: 16,
      ),
      Visibility(
          visible: showMobileNumField,
          child: padded(
              child: TextFormField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey[200])),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey[300])),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "(+Code){+91 default}10digits"),
            controller: _phoneController,
            key: Key('mobile'),
            autofocus: true,
            cursorColor: Colors.green,
            autocorrect: false,
            validator: (val) => val.isEmpty ? 'Field can\'t be empty.' : null,
//            onSaved: (val) => _mobileNo = val,
          ))),
      SizedBox(
        height: 16,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Color(0xFF8888AA)),
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            if (!showMobileNumField) {
              setState(() {
                showMobileNumField = true;
              });
            } else {
              showMobileNumField = true;
              setState(() {
                if (_phoneController.text.trim()[0] == '+') {
                  _mobileNo = _phoneController.text.trim();
                } else {
                  _mobileNo = "+91" + _phoneController.text.trim();
                }
              });

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return   Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              mobileLoginHelper().mobileSignInHandler(
                  context, _mobileNo, widget.onSignIn, auth);
            }
          },
          child: Text(
            "Sign In with Mobile No.",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
