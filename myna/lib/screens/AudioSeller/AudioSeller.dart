import 'package:flutter/material.dart';
import 'package:myna/components/Recorder.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';

class AudioBuyer extends StatefulWidget {
  @override
  _AudioBuyerState createState() => _AudioBuyerState();
}

class _AudioBuyerState extends State<AudioBuyer> {
  String recognisedWords = "waiting..";
  Questions allQuestions;
  int currentQuestionNumber;
  int audioState;
  /*
    1=> machine yet to speak
    2=>machine is speaking
    3=> we can speak
    4=> we spoke
   */
  String currentLanguage;

  @override
  void initState() {
    super.initState();
    currentLanguage = "en_IN";
    allQuestions.init(currentLanguage);
    audioState = 1;
    currentQuestionNumber = 0;
  }

  void callBackForRecorder(String data) {
    print("called");
    this.setState(() {
      recognisedWords = data;
    });
  }

  void incrementQuestionNumber() {
    if (this.currentQuestionNumber == allQuestions.questionStrings.length) {
      submit();
      return;
    }
    this.setState(() {
      currentQuestionNumber = currentQuestionNumber + 1;
      audioState = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(allQuestions.questionStrings[currentQuestionNumber]),
          Text("parent translated words: " + this.recognisedWords),

          RecorderSpeech(
            callbackFunction: this.callBackForRecorder,
            languageChangeCallBack: this.callBackForLanguageChange,
          ),
          // ),
        ],
      ),
    );
  }

  Future setLanguage(String data) async {
    await this.allQuestions.init(data);
    this.setState(() {
      currentLanguage = data;
    });
  }

  void submit() {
    print("submit");
  }

  void callBackForLanguageChange(String data) {
    setLanguage(data);
  }
}
