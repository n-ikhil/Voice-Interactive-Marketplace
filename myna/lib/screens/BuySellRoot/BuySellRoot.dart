import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:myna/components/buysellRecorder.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';
import 'package:myna/services/SharedObjects.dart';

class BuySellRoot extends StatefulWidget {
  final SharedObjects myModel;

  BuySellRoot(this.myModel);

  @override
  _BuySellRootState createState() => _BuySellRootState();
}

class _BuySellRootState extends State<BuySellRoot> {
  String recognisedWords = "waiting..";
  int audioState;
  FlutterTts flutterTts = FlutterTts();
  Question question;
  String currentLanguage;

  @override
  void initState() {
    print("init recalled");
    question = Question();
    super.initState();
    currentLanguage = widget.myModel.currentLanguage;
    audioState = 0;
    initTts();
    loadConvertedText();
  }

  void loadConvertedText() async {
    await question.QuestionSet(
      language: widget.myModel.currentLanguage,
      data: ["Would you like to buy or sell products", "rootbuysell", "button"],
    );
    incrementAudioState();
  }

  void incrementAudioState() async {
    this.setState(() {
      audioState++;
    });
    if (audioState == 1) {
      machineSpeak();
    }
    if (audioState == 2) {
      incrementAudioState();
    }
  }

  void callBackForRecorder(String data) {
    print("called");
    if (audioState != 3) {
      return;
    }
    this.setState(() {
      recognisedWords = data;
    });
    if (true) {
      // logic to determine if the spoken words were correct; else remain in same state
      incrementAudioState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  question.questionLanguage + " ?",
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),

          BuySellRecorder(
            callbackFunction: this.callBackForRecorder,
            languageChangeCallBack: this.callBackForLanguageChange,
            currentLanguage: this.currentLanguage,
          ),

          // ),
        ],
      ),
    );
  }

  Future setLanguage(String data) async {
    await widget.myModel.setLanguage(data);
    await setTtsLanguage();
    this.setState(() {
      audioState = 0;
    });
    loadConvertedText();
//    incrementAudioState();
  }

  void callBackForLanguageChange(String data) {
    setLanguage(data);
  }

  void setTtsLanguage() async {
    await flutterTts.setLanguage(widget.myModel.flutterLanguage);
  }

  void initTts() {
    flutterTts.setSpeechRate(0.8);
    flutterTts.setLanguage(widget.myModel.flutterLanguage);
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        // ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        // ttsState = TtsState.stopped;
      });
      machineStopped();
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        // ttsState = TtsState.stopped;
      });
      machineStopped();
    });
  }

  void machineSpeak() async {
    // if (audioState == 1) {
    await flutterTts.speak(question.questionLanguage);
  }

  void machineStopped() {
    // if (audioState == 1)
    incrementAudioState();
  }
}
