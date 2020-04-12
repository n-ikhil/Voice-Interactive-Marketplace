import 'package:farmers_mate_mate/chat_Page.dart'; 
import 'package:farmers_mate_mate/register.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';  
import 'dart:async'; 
import 'package:flutter_sound/flutter_sound.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String _email;
  String _password;

  //recorder
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Myna login'),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ));
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
            ],
          ),
        ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.greenAccent[100],
          radius: 150.0,
          //child: Image.asset('assets/flutter-icon.png'),
          child: Image.asset('assets/iitrpr_logo.jpeg'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.red,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.brown,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        
        child: SizedBox( 
          child:Column(
            
            children:<Widget>[

              new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.green,
                child: new Text('Login',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: validateAndSubmit,
              ), 
              
           new Padding(
             padding: EdgeInsets.fromLTRB(120.0, 10.0, 10.0, 5.0),
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
                Text('Voice login', style: new TextStyle(fontSize: 20.0, color: Colors.green) ),
              ],) ,),

            new FlatButton( 
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.yellow[100], 
                textColor: Colors.blue, 
                // padding: EdgeInsets.all(8.0), 
                child: new Text('Click here to Register',
                    style: new TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic,)),
                onPressed: (){   
                  Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        }
                   ),
        ],
      ),
    )
   );
  }
}