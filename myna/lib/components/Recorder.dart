import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myna/services/gtranslator.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef void StringCallback(String val);

class RecorderSpeech extends StatefulWidget {
  final StringCallback callbackFunction;
  final String currentLanguage;
  RecorderSpeech({this.callbackFunction, this.currentLanguage});
  @override
  _RecorderSpeechState createState() => _RecorderSpeechState();
}

class _RecorderSpeechState extends State<RecorderSpeech> {
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
    _currentLocaleId = widget.currentLanguage;
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
    // if (hasSpeech) {
    //   // _localeNames = await speech.locales();

    //   // var systemLocale = await speech.systemLocale();
    //   _currentLocaleId = systemLocale.localeId;
    // }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          child: Text("recognized in english as : " + this.convertedWords),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // SizedBox(
            //     width: 100,
            //     child: FlatButton(
            //       child: Text("lang: " + _currentLocaleId),
            //       onPressed: () {
            //         showLanguages(context);
            //       },
            //     )),
            lastWords.endsWith("true")
                ? Container(
                    child: RaisedButton(
                        child: Text("audio submit"),
                        onPressed: () {
                          widget.callbackFunction(this.convertedWords);
                          // translatedtext(lastWords);
                          //api call
                          //Navigator.pushNamed(context, '/ItemList');
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
        ),
      ],
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
      translatedtext(result.recognizedWords);
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
}
// _switchLang(selectedVal) {
//   widget.languageChangeCallBack(selectedVal);
//   print(selectedVal.split("_")[0]);
//   setState(() {
//     _currentLocaleId = selectedVal;
//   });
//   print(selectedVal);
// }

//   void showLanguages(context) {
//     showDialog(
//         child: Dialog(
//           child: SingleChildScrollView(
//             child: DropdownButton(
//               onChanged: (selectedVal) {
//                 _switchLang(selectedVal);
//                 Navigator.pop(context);
//               },
//               value: _currentLocaleId,
//               items: _localeNames
//                   .map(
//                     (localeName) => DropdownMenuItem(
//                       value: localeName.localeId,
//                       child: Text(
//                         localeName.name,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ),
//         context: context);
//   }
// }
