import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:myna/components/buysellRecorder.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';

class BuySellRoot extends StatefulWidget {
  @override
  _BuySellRootState createState() => _BuySellRootState();
}

class _BuySellRootState extends State<BuySellRoot> {
  String recognisedWords = "waiting..";
  int audioState;
  FlutterTts flutterTts = FlutterTts();
  Question question = Question(
    language: 'en_IN',
    data: ["Would you like to buy or sell products", "rootbuysell", "button"],
  );
  String currentLanguage;

  @override
  void initState() {
    super.initState();
    currentLanguage = "en_IN";
    audioState = 0;
    initTts();
    incrementAudioState();
  }

  void incrementAudioState() {
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
          ),

          // ),
        ],
      ),
    );
  }

  Future setLanguage(String data) async {
    await changeMachineLanguage(data);
    await question.setLanguage(data);
    //await this.allQuestions.init(data);

    this.setState(() {
      currentLanguage = data;
      audioState = 0;
    });
    incrementAudioState();
  }

  void callBackForLanguageChange(String data) {
    setLanguage(data);
  }

  void initTts() {
    flutterTts.setSpeechRate(0.8);
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

  Future changeMachineLanguage(String data) async {
    // final languages = await flutterTts.getLanguages;
    // print(languages);
    var tlang = data;
    tlang = tlang.replaceAll("_", "-");
    print(tlang);
    var isGoodLanguage = await flutterTts.isLanguageAvailable(tlang);
    if (isGoodLanguage) {
      // print("yup");
      await flutterTts.setLanguage(tlang);
    }
  }

  void machineStopped() {
    // if (audioState == 1)
    incrementAudioState();
  }
}
