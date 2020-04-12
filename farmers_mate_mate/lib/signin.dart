
import 'package:flutter/material.dart';  
import 'package:farmers_mate_mate/chat_Page.dart'; 
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat; 
import 'dart:async'; 
import 'package:flutter_sound/flutter_sound.dart';
import 'contact.dart';


enum AuthMode { LOGIN, SINGUP }

class SigninPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<SigninPage> {
  
  double screenHeight; 
  AuthMode _authMode = AuthMode.LOGIN; 

   String _email;
   String _password;

  bool _isRecording = false; 
  bool _location = false; 

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription; 

  FlutterSound flutterSound = new FlutterSound();

  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double _dbLevel; 

  List<String> _userTypes = <String>['','supplier', 'buyer'];
  List<String> category_list = <String>['','seeds', 'chemical','instruments','vehicles'];
  String _userType = '';
  String category= '';

  Contact newContact = new Contact();

  
  void validateAndSubmit(){
    setState(() {
      
    });
    String userId = _email;
    print('Signed in: $userId, with password $_password .');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBoatScreen()),
    );
  }

      void startRecorder() async {
    try {
      String path = await flutterSound.startRecorder();
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'pt_BR').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }


bool isValidEmail(String input) {
   if(input.isEmpty)
      return false;
    else {
        final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        return regex.hasMatch(input);
      }
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            _authMode == AuthMode.LOGIN
                ? loginCard(context)
                : singUpCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }
  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            size: 48,
            color: Colors.lightGreen[700],
          ),
          Text(
            "Myna App",
            style: TextStyle(
                fontSize: 34, color: Colors.yellow[900],fontWeight: FontWeight.bold,
                  background: Paint()..color = Colors.yellowAccent[100],),
          )
        ],
      ),
    );
  }
  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email', 
                    ),
                    keyboardType: TextInputType.emailAddress, 
                    validator: (value) => isValidEmail(value) ? null : 'Please enter a valid email address',
                    ),
                  SizedBox(
                    height: 20,
                  ),
                   TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter a password',
                      labelText: 'password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Forgot Password ?"),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        child: Text("Login"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        // onPressed:  _submitForm,
                        onPressed:    validateAndSubmit,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row( 
                   mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                      Text('Voice login', style: new TextStyle(fontSize: 15.0, color: Colors.blue) ),
                      new  FloatingActionButton(
                        heroTag: "btn1", 
                        onPressed: () {
                              if (!this._isRecording) {
                                return this.startRecorder();
                                }
                                this.stopRecorder();
                            },
                        child:  this._isRecording ? Icon(Icons.stop) : Icon(Icons.mic),   
                              ), 
                      ],),
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Don't have an account ?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.SINGUP;
                });
              },
              textColor: Colors.black87,
              child: Text("Create Account"),
            )
          ],
        )
      ],
    );
  }

bool isValidPhoneNumber(String input) { 
  print(input);
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }
  Widget singUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 5),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                 TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter the your name',
                      labelText: 'Your Name',
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      new WhitelistingTextInputFormatter(new RegExp(r'^[()\d -]{1,15}$')),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (val){ 
                    },
                    validator: (value) {return isValidPhoneNumber(value) ? null : 'Phone number must be entered as (###)###-####';},
                  ),
                  SizedBox(
                    height: 15,
                  ), 
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter a password',
                      labelText: 'password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter the password again',
                      labelText: 'confirm password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.home),
                      hintText: 'Enter address',
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),

                  Text(
                    " type manually or use Gps location",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ), 

                  Row( 
                    mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        Text('Gps_location', style: new TextStyle(fontSize: 15.0, color: Colors.blue) ),
                      
                        new  FloatingActionButton(
                          heroTag: "btn3",  
                          child:this._location ? Icon(Icons.gps_fixed) : Icon(Icons.gps_not_fixed), 
                          onPressed:  ( ) {
                              setState(() {
                                _location = _location ?false: true;
                                    },);
                                }
                          ), 
                      ],
                  ),

                  SizedBox(
                    height: 20,
                  ), 

                  new FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.group_add),
                        labelText: 'user_type',
                      ),
                      isEmpty: _userType == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: _userType,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() { 
                              _userType = newValue;
                              state.didChange(newValue); 
                            });
                          },
                          items: _userTypes.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  validator: (val) { return val != '' ? null : 'Please select a user_type';},
                ), 
                
                  SizedBox(
                    height: 20,
                  ),

                  _userType== "buyer"?Text(""):
                        new FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.category),
                              labelText: 'Category',
                            ),
                            isEmpty: category == '',
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton(
                                value: category,
                                isDense: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    category = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: category_list.map((String value) {
                                  return new DropdownMenuItem(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                        validator: (val) {
                                  return val != '' ? null : 'Please select a category';
                                },
                      ),
                      
                  SizedBox(
                    height: 20,
                  ),
                  Row( 
                   mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                      Text('Voice_register', style: new TextStyle(fontSize: 15.0, color: Colors.blue) ),
                      new  FloatingActionButton(
                        heroTag: "btn2", 
                        onPressed: () {
                              if (!this._isRecording) {
                                return this.startRecorder();
                                }
                                this.stopRecorder();
                            },
                        child:  this._isRecording ? Icon(Icons.stop) : Icon(Icons.mic),   
                              ), 
                      ],),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "* Password must be at least 8 characters and include a special character and number",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        child: Text("Sign Up"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Already have an account?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.LOGIN;
                });
              },
              textColor: Colors.black87,
              child: Text("Login"),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlatButton(
            child: Text(
              "Terms & Conditions",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/iitrpr_logo.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }
  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }
}