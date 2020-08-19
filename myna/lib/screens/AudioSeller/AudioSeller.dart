import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:myna/components/Recorder.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';

class AudioSeller extends StatefulWidget {
  @override
  _AudioSellerState createState() => _AudioSellerState();
}

class _AudioSellerState extends State<AudioSeller> {
  String recognisedWords = "waiting..";
  QuestionCard allQuestions;
  int currentQuestionNumber;
  int audioState;
  FlutterTts flutterTts = FlutterTts();
  // Ttsstate ttsState = TtsState.stopped;
  /*
    0=>setup
    1=> machine can to speak
    2=>machine has spoke
    3=> we can speak
    4=> we spoke
   */
  String currentLanguage;

  @override
  void initState() {
    super.initState();
    currentLanguage = "en_IN";
    allQuestions = QuestionCard(curLang: currentLanguage);
    audioState = 0;
    currentQuestionNumber = 0;
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
      // if current question doesnt want audio input then do not icrement
      incrementAudioState();
    }
    if (audioState == 4) {
      print(allQuestions.questions[currentQuestionNumber].questionLanguage +
          "-" +
          recognisedWords);
      incrementQuestionNumber();
    }
  }

  void machineSpeak() async {
    // if (audioState == 1) {
    await flutterTts
        .speak(allQuestions.questions[currentQuestionNumber].questionLanguage);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
    // }
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

  void incrementQuestionNumber() {
    if (this.currentQuestionNumber == allQuestions.questions.length - 1) {
      submit();
      return;
    }
    this.setState(() {
      currentQuestionNumber = currentQuestionNumber + 1;
      audioState = 0;
      recognisedWords = "wating...";
    });
    incrementAudioState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            allQuestions.questions[currentQuestionNumber].questionLanguage,
            style: TextStyle(fontSize: 28),
          ),
          Text("Your answer: " + this.recognisedWords),

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
    await changeMachineLanguage(data);
    await this.allQuestions.init(data);

    this.setState(() {
      currentLanguage = data;
      audioState = 0;
    });
    incrementAudioState();
  }

  void submit() {
    print("submit");
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
}
