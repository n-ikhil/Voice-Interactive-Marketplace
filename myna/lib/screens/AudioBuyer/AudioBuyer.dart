import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:myna/components/Recorder.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';
import 'package:myna/services/apiHandler.dart';
import 'package:translator/translator.dart';

class AudioBuyer extends StatefulWidget {
  @override
  _AudioBuyerState createState() => _AudioBuyerState();
}

class _AudioBuyerState extends State<AudioBuyer> {
  String recognisedWords = "waiting..";
  Question question;
  int currentQuestionNumber;
  int audioState;
  FlutterTts flutterTts = FlutterTts();
  List<dynamic> recordedAnswers;
  String currentLanguage;
  String convertedWords = "";

  @override
  void initState() {
    recordedAnswers = [];
    super.initState();
    currentLanguage = "en_IN";
    question = Question(
      language: currentLanguage,
      data: ["Which product you want to buy", "buyer", "audio"],
    );
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
    if (audioState == 3) {
      print("forwarddin listining to voice");
      // myAnimation.forward();
    }
    if (audioState == 4) {
      print(question.questionLanguage + "-" + recognisedWords);
      //incrementQuestionNumber();
    }
  }

  void translatedtext(String lastWords) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(lastWords,
        from: currentLanguage.split("_")[0], to: 'en');

    setState(() {
      convertedWords = translation.toString();
    });
  }

  void callBackForRecorder(String data) async {
    print("called");
    if (audioState != 3) {
      return;
    }
    this.setState(() {
      recognisedWords = data;
    });
    if (true) {
      // logic to determine if the spoken words were correct; else remain in same state
      //incrementAudioState();
      await translatedtext(recognisedWords);
      convertedWords = convertedWords.toLowerCase();
      String prodid = await productData(convertedWords);
      print("-------------------${prodid}");

      if (prodid == "") {
        print("could not understand the query");
        setState(() {
          convertedWords = "could not understand the query";
        });
      } else {
        await Navigator.pushNamed(context, itemList, arguments: {'id': prodid});
        print(prodid);
      }
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
              child: Center(
                child: Text(
                  question.questionLanguage + " ?",
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),
          // Text("Your answer: " + this.recognisedWords),
          Container(
            child: Text(convertedWords),
          ),
          this.audioState == 3
              ? Expanded(
                  child: Column(
                  children: <Widget>[
                    Text("Listening ...", style: TextStyle(fontSize: 20)),
                    Text("(press mic icon below)",
                        style: TextStyle(fontSize: 7)),
                  ],
                ))
              : Container(width: 0, height: 0),

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
    //await this.allQuestions.init(data);
    await question.setLanguage(data);

    this.setState(() {
      currentLanguage = data;
      audioState = 0;
    });
    incrementAudioState();
  }

  // void submit() {
  //   for (int i = 0; i < recordedAnswers.length; i++) {
  //     print(i.toString() + recordedAnswers[i]);
  //   }
  //   print("submit");
  // }

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
}
