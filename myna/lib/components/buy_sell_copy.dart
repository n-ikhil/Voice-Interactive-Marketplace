import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/services/gtranslator.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef void StringCallback(String val);

class BuySellRecorder extends StatefulWidget {
  final StringCallback callbackFunction;
  final StringCallback languageChangeCallBack;
  final String currentLanguage;
  BuySellRecorder(
      {this.callbackFunction,
      this.languageChangeCallBack,
      this.currentLanguage});
  @override
  _BuySellRecorderState createState() => _BuySellRecorderState();
}

class _BuySellRecorderState extends State<BuySellRecorder> {
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
    this._currentLocaleId = widget.currentLanguage;
    print('entered to initstate of buy sell recorder');
    print(_currentLocaleId);
    super.initState();
    initSpeechState();
  }

  void translatedtext(String lastWords) async {
    await googleTranslateToEnglish(lastWords, _currentLocaleId).then((onValue) {
      setState(() {
        convertedWords = onValue;
      });
    });
  }

  Future<void> initSpeechState() async {
    print("eneterd to initspeech state");
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      // var systemLocale = await speech.systemLocale();
      // _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        child: SizedBox(
            width: 150,
            height: 100,
            child: FlatButton(
              child: Text("language: " + _currentLocaleId),
              onPressed: () {
                showLanguages(context);
              },
            )),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: RaisedButton(
              child: Text('Buy'),
              onPressed: () {
                Navigator.pushNamed(context, audioBuyer);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: RaisedButton(
              child: Text('Sell'),
              onPressed: () {
                Navigator.pushNamed(context, audioSeller);
              },
            ),
          ),
        ],
      ),
      Container(
        child: Text("recognized in english as : " + this.convertedWords),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          lastWords.endsWith("true")
              ? Container(
                  child: RaisedButton(
                      child: Text("audio submit"),
                      onPressed: () {
                        widget.callbackFunction(this.convertedWords);
                      }),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          RaisedButton(
            //child: Text('Start'),
            child: Icon(
              Icons.mic,
              color: speech.isListening ? Colors.orange : Colors.white,
            ),
            color: Colors.green,
            onPressed: () {
              !_hasSpeech || speech.isListening ? null : startListening();
            },
          ),
        ],
      )
    ]);
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
    print("this is listener in recorder");
    if (result.finalResult) {
      await translatedtext(result.recognizedWords);
    }
    print(lastWords);
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
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
    widget.languageChangeCallBack(selectedVal);
    print(selectedVal.split("_")[0]);
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void showLanguages(context) {
    showDialog(
        child: Dialog(
          child: SingleChildScrollView(
            child: DropdownButton(
              onChanged: (selectedVal) {
                _switchLang(selectedVal);
                Navigator.pop(context);
              },
              value: _currentLocaleId,
              items: _localeNames
                  .map(
                    (localeName) => DropdownMenuItem(
                      value: localeName.localeId,
                      child: Text(
                        localeName.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        context: context);
  }
}
