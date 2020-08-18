import 'dart:async';
import 'dart:ffi';
// import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class SpeechTextCon extends StatefulWidget {
  @override
  _SpeechTextConState createState() => _SpeechTextConState();
}

class _SpeechTextConState extends State<SpeechTextCon> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String convertedWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    print('entered to initstate');
    super.initState();
    initSpeechState();

  }

  void translatedtext(String lastWords) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(lastWords,
        from: _currentLocaleId.split("_")[0], to: 'en');

    setState(() {
      convertedWords = translation.toString();
    });
  }

  Future<void> initSpeechState() async {
    print("eneterd to initspeech state");
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          Center(
            child: Text(
              'Speech recognition available',
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //     FlatButton(
                //       child: Text('Initialize'),
                //       //onPressed: _hasSpeech ? null : initSpeechState,
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      //child: Text('Start'),
                      child: Icon(Icons.mic),

                      onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                    ),
                    // FlatButton(
                    //   child: Text('Stop'),
                    //   onPressed: speech.isListening ? stopListening : null,
                    // ),
                    // FlatButton(
                    //   child: Text('Cancel'),
                    //   onPressed: speech.isListening ? cancelListening : null,
                    // ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
 
                SizedBox(
                  height: 80,
                ),

                Center(
                  child: Text(
                    'Recognized Words',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        //padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            convertedWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        //padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 20, left: 100),
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 1.5,
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: IconButton(icon: Icon(Icons.mic)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     children: <Widget>[
          //       Center(
          //         child: Text(
          //           'Error Status',
          //           style: TextStyle(fontSize: 22.0),
          //         ),),
          //       Center(
          //         child: Text(lastError),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            child: RaisedButton(
              child: Text('send'),
              onPressed: () {
                translatedtext(lastWords);
                //api call
                //Navigator.pushNamed(context, '/ItemList');

              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  void startListening() {
    lastWords = "";
    convertedWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);

    setState(() {});
    // translatedtext(lastWords);
    //getItemResults(convertedWords);
    // print("----------------------########-----------------");
    // print(convertedWords);
    // Navigator.pushNamed(context, '/newItem');

  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });

    // Navigator0Cs.Navigator.pushNamed(context, '/second');s.g /
    //Navigator.pushNamed(context, '/NewItem');

  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    print(selectedVal.split("_")[0]);
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
