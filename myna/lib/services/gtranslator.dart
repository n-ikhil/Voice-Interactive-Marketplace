import 'package:translator/translator.dart';

Future<String> googleTranslateToEnglish(
    String lastWords, String currentLocaleId) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(lastWords,
      from: currentLocaleId.split("_")[0], to: 'en');
  return translation.toString();
}

Future<String> googleTranslateEnglishToSpecified(
    String lastWords, String currentLocaleId) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(lastWords,
      from: 'en', to: currentLocaleId.split("_")[0]);
  return translation.toString();
}
