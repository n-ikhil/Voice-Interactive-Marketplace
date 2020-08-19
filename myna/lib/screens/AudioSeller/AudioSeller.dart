import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myna/components/Loading.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:myna/components/Recorder.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/quesionCards.dart';
import 'package:myna/services/SharedObjects.dart';

class AudioSeller extends StatefulWidget {
  final SharedObjects myModel;
  AudioSeller({this.myModel});
  @override
  _AudioSellerState createState() => _AudioSellerState();
}

class _AudioSellerState extends State<AudioSeller> {
  String recognisedWords = "waiting..";
  QuestionCard allQuestions;
  int currentQuestionNumber;
  int audioState;
  FlutterTts flutterTts = FlutterTts();
  List<dynamic> recordedAnswers;
  TextEditingController _newContactTextController;
  File _image;
  String _imageName = "please add image";
  bool showSpinner;
  var focusNode = FocusNode();

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
    showSpinner = false;
    _newContactTextController = TextEditingController();
    recordedAnswers = [];
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
    if (audioState == 3) {
      print("forwarddin listining to voice");
      // myAnimation.forward();
    }
    if (audioState == 4) {
      print(allQuestions.questions[currentQuestionNumber].questionLanguage +
          "-" +
          recognisedWords);
      incrementQuestionNumber();
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
    _newContactTextController.clear();
  }

  void incrementQuestionNumber() {
    List ans = [
      recognisedWords,
      allQuestions.questions[currentQuestionNumber].id
    ];
    recordedAnswers.add(ans);

    if (this.currentQuestionNumber == allQuestions.questions.length - 1) {
      submit();
      return;
    }
    this.setState(() {
      currentQuestionNumber = currentQuestionNumber + 1;
      audioState = 0;
      recognisedWords = "NA";
    });
    focusNode.requestFocus();
    incrementAudioState();
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
            child: showSpinner
                ? LoadingWidget()
                : Container(
                    child: Center(
                      child: Text(
                        allQuestions.questions[currentQuestionNumber]
                                .questionLanguage +
                            " ?",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
          ),
          // Text("Your answer: " + this.recognisedWords),

          (this.audioState == 3
              ? (allQuestions.questions[currentQuestionNumber].type == "audio"
                  ? Expanded(
                      child: Column(
                      children: <Widget>[
                        Text("Listening ...", style: TextStyle(fontSize: 20)),
                        Text("(press mic icon below)",
                            style: TextStyle(fontSize: 7)),
                      ],
                    ))
                  : (allQuestions.questions[currentQuestionNumber].type ==
                          "boolButton"
                      ? Expanded(
                          child: Column(
                          children: <Widget>[
                            RaisedButton(
                                onPressed: () => callBackForRecorder("yes"),
                                child: Text("Yes",
                                    style: TextStyle(fontSize: 20))),
                            RaisedButton(
                                onPressed: () => callBackForRecorder("no"),
                                child:
                                    Text("no", style: TextStyle(fontSize: 20))),
                          ],
                        ))
                      : (allQuestions.questions[currentQuestionNumber].type ==
                              "keyPad"
                          ? Expanded(
                              child: Column(
                              children: <Widget>[
                                TextField(
                                  autofocus: true,
                                  controller: _newContactTextController,
                                  decoration:
                                      InputDecoration(labelText: "enter here"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ], // Only numbers can be entered
                                ),
                                RaisedButton(
                                    onPressed: () => callBackForRecorder(
                                        _newContactTextController.text),
                                    child: Text("Submit",
                                        style: TextStyle(fontSize: 20))),
                              ],
                            ))
                          : (allQuestions
                                      .questions[currentQuestionNumber].type ==
                                  "file"
                              ? Expanded(
                                  child: Column(
                                  children: <Widget>[
                                    Text(_imageName),
                                    RaisedButton.icon(
                                        onPressed: this.getImage,
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          size: 100,
                                        ),
                                        // label: 'add image',
                                        label: Text("add")),
                                    RaisedButton(
                                        onPressed: showSpinner
                                            ? null
                                            : this.imageSubmit,
                                        child: Text("next",
                                            style: TextStyle(fontSize: 20))),
                                  ],
                                ))
                              : Container(width: 0, height: 0)))))
              : Container(width: 0, height: 0)),

          RecorderSpeech(
            callbackFunction: this.callBackForRecorder,
            languageChangeCallBack: this.callBackForLanguageChange,
          )
          // ),
        ],
      ),
    );
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageName = (image.path.split(Platform.pathSeparator).last);
      _image = image;
    });
  }

  Future setLanguage(String data) async {
    this.setState(() {
      showSpinner = true;
    });
    await changeMachineLanguage(data);
    await this.allQuestions.init(data);

    this.setState(() {
      currentLanguage = data;
      audioState = 0;
      showSpinner = false;
    });
    incrementAudioState();
  }

  Future imageSubmit() async {
    setState(() {
      showSpinner = true;
    });
    String imgURL = "";
    try {
      if (_image != null) {
        print("saving  the image");
        String curDateTime =
            DateFormat('EEE|d|MMM-kk:mm:ss').format(DateTime.now());
        imgURL = await widget.myModel.firestoreClientInstance.storageClient
            .uploadItemImage(
                _image, widget.myModel.currentUser.userID + ":" + curDateTime);
        print("image saved with url $imgURL");
        if (imgURL == null) {
          setState(() {
            showSpinner = false;
          });
          print("error uploading the image");
        }
        print("submit");
      }
    } finally {
      setState(() {
        showSpinner = false;
      });
      callBackForRecorder(imgURL);
      return;
    }
  }

  Future submit() async {
    for (int i = 0; i < recordedAnswers.length; i++) {
      print(recordedAnswers[i][0] + " " + recordedAnswers[i][1]);
    }
  }

  void callBackForLanguageChange(String data) {
    setLanguage(data);
  }

  void initTts() {
    flutterTts.setSpeechRate(0.8);
    flutterTts.setLanguage("en-IN");
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
    await flutterTts
        .speak(allQuestions.questions[currentQuestionNumber].questionLanguage);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
    // }
  }

  Future changeMachineLanguage(String data) async {
    // final languages = await flutterTts.getLanguages;
    // print(languages);
    print("changing machine langue");
    // print(data);
    var tlang = data;
    tlang = tlang.replaceAll("_", "-");
    // print(tlang);
    print("check");
    var isGoodLanguage = await flutterTts.isLanguageAvailable(tlang);
    if (isGoodLanguage) {
      print("yup");
      await flutterTts.setLanguage(tlang);
    } else {
      await flutterTts.setLanguage("hi-IN"); // fallback
    }
  }

  void machineStopped() {
    // if (audioState == 1)
    incrementAudioState();
  }
}
