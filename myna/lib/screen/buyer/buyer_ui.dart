import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'package:feedback/feedback.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:geolocator/geolocator.dart';

List<Lang> languages = [
  const Lang('Hindi', 'hi_IN'),
  const Lang('English', 'en_US'),
  const Lang('Kannad', 'kn_IN'),
  const Lang('Marathi', 'mr_IN'),
  const Lang('Bengali', 'bn_IN'),
  const Lang('Telgu', 'te_IN'),
  const Lang('Arabic', 'ar_AE'),
  const Lang('punjabi', 'pa_guru_IN'),
];

class Lang {
  final String name;
  final String code;

  const Lang(this.name, this.code);
}

class ChatBoatScreen extends StatefulWidget {
  const ChatBoatScreen({Key key}) : super(key: key);
  @override
  _LandingScreenState createState() => _LandingScreenState();
}
//////////////////////////
///

class _LandingScreenState extends State<ChatBoatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  bool _isRecording = false;
  bool _location = false;
  bool isChecked = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  FlutterSound flutterSound = new FlutterSound();
  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double _dbLevel;

  SpeechToText _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  Position position;
  String transcription = '';
  //String _currentLocale = 'en_US';
  Lang selectedLang = languages.first;
  GeolocationStatus geolocationStatus;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    // geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> activateSpeechRecognizer() async {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechToText();
    _speechRecognitionAvailable = await _speech.initialize(
        onError: errorHandler, onStatus: onSpeechAvailability);
    List<LocaleName> localeNames = await _speech.locales();
    languages.clear();
    localeNames.forEach((localeName) =>
        languages.add(Lang(localeName.name, localeName.localeId)));
    var currentLocale = await _speech.systemLocale();
    if (null != currentLocale) {
      selectedLang =
          languages.firstWhere((lang) => lang.code == currentLocale.localeId);
    }
    setState(() {});
  }

  List<CheckedPopupMenuItem<Lang>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Lang>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Lang lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech.listen(
      onResult: onRecognitionResult, localeId: selectedLang.code);

  void cancel() {
    _speech.cancel();
    setState(() => _isListening = false);
  }

  void stop() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void onSpeechAvailability(String status) {
    setState(() {
      _speechRecognitionAvailable = _speech.isAvailable;
      _isListening = _speech.isListening;
    });
  }

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(SpeechRecognitionResult result) =>
      setState(() => transcription = result.recognizedWords);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler(SpeechRecognitionError error) => print(error);

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

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey.shade200,
                child: new Text(transcription)),
            Padding(
              padding: EdgeInsets.fromLTRB(100, 5, 5, 5),
              child: new Row(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      _speechRecognitionAvailable && !_isListening
                          ? start()
                          : stop();
                      // if (!this._isRecording) {
                      //   return this.startRecorder();
                      //   }
                      //   this.stopRecorder();
                    },
                    child: _isListening ? Icon(Icons.stop) : Icon(Icons.mic),
                  ),
                  this._isListening
                      ? Text('  Listening...',
                          style: TextStyle(color: Colors.green))
                      : Text(' Listen (${selectedLang.code})',
                          style: TextStyle(color: Colors.brown)),
                ],
              ),
            ),
            new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () => _handleSubmitted(_textController.text)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Promise",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        excludeHeaderSemantics: true,
        // centerTitle: true,
        title: new Text(
          "Chat Page",
          style: TextStyle(fontSize: 22),
        ),
        actions: <Widget>[
        //   CustomSwitch(
        //     activeColor: Colors.yellow[900],
        //     value: isChecked,
        //     onChanged: (value) {
        //       print("VALUE : $value");
        //       setState(() {
        //         isChecked = !value;
        //       });
        //     },
        //   ),R
          new PopupMenuButton<Lang>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          ),
        //   new FloatingActionButton(
        //       heroTag: "btn3",
        //       child: this._location
        //           ? Icon(Icons.gps_fixed, color: Colors.yellow, size: 40)
        //           : Icon(Icons.gps_not_fixed, color: Colors.red, size: 40),
        //       onPressed: () async {
        //         setState(
        //           () {
        //             _location = _location ? false : true;
        //           },
        //         );

        //         if (_location == true) {
        //           Geolocator geolocator = Geolocator()
        //             ..forceAndroidLocationManager = true;
        //           GeolocationStatus geolocationStatus =
        //               await geolocator.checkGeolocationPermissionStatus();
        //           // print(geolocationStatus  ==  GeolocationStatus.granted  );
        //           if (geolocationStatus == GeolocationStatus.granted) {
        //             try {
        //               position = await Geolocator().getCurrentPosition(
        //                   desiredAccuracy: LocationAccuracy.high);
        //             } catch (err) {
        //               print(err);
        //               try {
        //                 position = await Geolocator().getLastKnownPosition(
        //                     desiredAccuracy: LocationAccuracy.high);
        //               } catch (err) {
        //                 print(err);
        //               }
        //             }
        //             print(position == null
        //                 ? 'Unknown'
        //                 : position.latitude.toString() +
        //                     ', ' +
        //                     position.longitude.toString());
        //           } else
        //             print(geolocationStatus);
        //         }
        //       }),
        ],
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text('B')),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            child: new Text(
          this.name[0],
          style: new TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
