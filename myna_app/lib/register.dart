import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_Page.dart';  
import 'dart:async'; 
import 'package:myna_app/chat_Page.dart'; 
import 'package:intl/intl.dart' show DateFormat; 
import 'package:flutter_sound/flutter_sound.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _email;
  String _firstName;
  String _lastName;
   String _password_1;
   String _password_2;
   bool _isLoading = false;  
  bool _isRecording = false; 
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription; 
  FlutterSound flutterSound = new FlutterSound();
  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double _dbLevel; 

  
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

 

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    //   systemNavigationBarColor: Colors.blue,
    //   statusBarColor: Colors.red));
    return new Scaffold( 

      appBar: AppBar(
        title: Text("Myna App ", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
            FlatButton(
              onPressed: () {              
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ChatBoatScreen()), (Route<dynamic> route) => false);
              },
               child: Icon( Icons.home,  color: Colors.white, size: 50.0, semanticLabel: 'Main', ),
            ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            _showForm(),
          ],
        ),
      ),
    );
  }

  
//  TextEditingController emailController = new TextEditingController();
//  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  
  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[ 
              Padding(padding: const EdgeInsets.fromLTRB(80.0, 0.0, 0.0, 10.0),
                  child: Text("Registration Page", style : TextStyle(color: Colors.yellow[700], fontSize: 20, fontWeight: FontWeight.bold,),),),
              showNameInput(),
              showEmailInput(),
              showPasswordInput(1),
              showPasswordInput(2),
              // showAddressInput(),
              // voiceSampleInput(),
              showPrimaryButton(), 
            ],
          ),
        ));
  }

  Widget showNameInput(){ 
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
            new TextFormField(
                maxLines: 1,
                decoration: new InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(color: Colors.white),
                    icon: new Icon(
                      Icons.person,
                      color: Colors.brown[400],
                    )),
                    
                keyboardType: TextInputType.emailAddress,  

                validator: validateEmail,
                onSaved: (String val) {
                  print("in onsave of _firstName");
                  print("$val");
                  _firstName= val;
                }, 
              ),


            new TextFormField(
                maxLines: 1,
                decoration: new InputDecoration(
                    hintText: 'Last Name',
                    hintStyle: TextStyle(color: Colors.white),
                    icon: new Icon(
                      Icons.person,
                      color: Colors.brown[400],
                    )),
                    
                keyboardType: TextInputType.emailAddress,  

                validator: validateEmail,
                onSaved: (String val) {
                  print("in onsave of last name");
                  print("$val");
                  _lastName= val;
                }, 
              ),
        ],)
        
    );
  }
  Widget showAddressInput(){
      
  }
  Widget voiceSampleInput(){

  }

  String message(String value)
  {
    print("Empty Email address");
    return "Empty";
  }
  String message2(String value)
  {
    print("$value");
    return "Not Empty";
  }

  Widget showEmailInput() { 
    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        decoration: new InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.white),
            icon: new Icon(
              Icons.mail,
              color: Colors.red[400],
            )),
            
        keyboardType: TextInputType.emailAddress,  

        validator: validateEmail,
        onSaved: (String val) {
          print("in onsave of email");
          print("$val");
          _email= val;
        },

      ),
    );
  }

  Widget showPasswordInput(int password_num) {  
    if(password_num ==1)

      return new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.white),
              icon: new Icon(
                Icons.lock,
                color: Colors.yellow[200],
              )),

          keyboardType: TextInputType.text, 

          validator: validatePassword,
          onSaved: (String val) {
            _password_1= val;
          },

        ),
      );

    else  

      return new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: new TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: TextStyle(color: Colors.white),
                icon: new Icon(
                  Icons.lock,
                  color: Colors.yellow[200],
                )),

            keyboardType: TextInputType.text,    

            validator: validatePassword,
            onSaved: (String val) {
              _password_2= val;
            },
          ),
        );
  }


  String validatePassword(String value) {  
      if (value.length <= 6)
        return 'Password must be of greater that 6 digit size !';
      else
        return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  List password_verification (String password)
  {
      if (password?.isEmpty ?? true)
        return [false, "Password Required"];
      else if (password.length < 6)
        return [false,"The Password Requires 6 Characters Or More"];
      else
        return [true,"Acceptable Password"];  
  }
  

  List match_password (String password_1, String password_2)
  {
      if (password_verification(password_1)[0] ==  true && password_verification(password_2)[0] ==  true ){
        if (password_1 == password_2)
          return [true, "Acceptable Password"];
        else 
          return [false,"non-matching passwords !! "]; 
      }
      else if( password_verification(password_1)[0] ==  false ){
        String reason = password_verification(password_1)[1];
        return [false,  reason];
      }
      else{
        String reason = password_verification(password_2)[1];
        return [false,  reason];
      }

  }

  void validateAndSubmit(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('valid');
    }

    String userId = _email;
    print('Signed in: $userId, with password $_password_1 .');

    if (validateEmail(_email) == null  && match_password (_password_1, _password_2)[0] == true )
    {
      setState(() {
        _isLoading = true;
      });
      signIn(_email, _password_1); 
    }
    else{
        if ( validateEmail(_email) != null ){
          print("Invalid Email Address !!");
        }
      else{
          String reason = match_password (_password_1, _password_2)[1];
          print("$reason");
        }
    } 
  }
 


  signIn(String email , String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'email': email,
      'password': pass
    };
    
    String jasonStringLogin = json.encode(data); 
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ChatBoatScreen()), (Route<dynamic> route) => false);

    // String url_login = "http://127.0.0.1:8000/login/" ;
    // var response = await http.post(url_login , body: jasonStringLogin);
    
    
    // var jsonResponse;
    // if(response.statusCode == 200) {
    //   jsonResponse = json.decode(response.body);

    //   if(jsonResponse != null) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     sharedPreferences.setString("token", jsonResponse['token']);
    //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Homepage()), (Route<dynamic> route) => false);
    //   }
    // }
    // else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   print(response.body);
    // }
  }



Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        
        child: SizedBox( 
          child:Column(
            
            children:<Widget>[

              new Padding(
             padding: EdgeInsets.fromLTRB(80.0, 10.0, 20.0, 20.0),
             child : Row( 
                //  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
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
                Text('Voice Register', style: new TextStyle(fontSize: 20.0, color: Colors.yellow) ),
              ],) ,),


              new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                child: new Text('Register',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: (){},
              ), 

            // new FlatButton( 
            //     shape: new RoundedRectangleBorder(
            //         borderRadius: new BorderRadius.circular(30.0)),
            //     color: Colors.yellow[100], 
            //     textColor: Colors.blue, 
            //     // padding: EdgeInsets.all(8.0), 
            //     child: new Text('Click here to Register',
            //         style: new TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic,)),
            //     onPressed: (){   
            //       Navigator.push(
            //                 context,
            //                   MaterialPageRoute(builder: (context) => RegisterPage()),
            //               );
            //             }
            //        ),
        ],
      ),
    )
   );
  }

 
}



