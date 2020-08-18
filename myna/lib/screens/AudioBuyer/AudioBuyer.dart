import 'package:flutter/material.dart';
import 'package:myna/components/Recorder.dart';
import 'package:myna/constants/variables/common.dart';

class AudioBuyer extends StatefulWidget {
  @override
  _AudioBuyerState createState() => _AudioBuyerState();
}

class _AudioBuyerState extends State<AudioBuyer> {
  String recognisedWords = "waiting..";
  @override
  void initState() {
    super.initState();
  }

  void callBackForRecorder(String data) {
    print("called");
    this.setState(() {
      recognisedWords = data;
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
          Text("parent translated words: " + this.recognisedWords),

          RecorderSpeech(
            callbackFunction: this.callBackForRecorder,
          ),
          // ),
        ],
      ),
    );
  }
}
