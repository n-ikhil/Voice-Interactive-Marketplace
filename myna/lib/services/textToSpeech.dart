import 'package:flutter_tts/flutter_tts.dart';

Future<String> getTtsCompliantLanguageCode(String csdcoprCode) async {
  print("changing machine langue");
  var tlang = csdcoprCode;
  tlang = tlang.replaceAll("_", "-");
  print("check");
  var isGoodLanguage = await FlutterTts().isLanguageAvailable(tlang);
  if (isGoodLanguage) {
    return tlang;
  } else {
    return "hi-IN";
  }
}
