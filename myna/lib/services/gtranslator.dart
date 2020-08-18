import 'package:translator/translator.dart';

Future<String> googleTranslatedtext(
    String lastWords, String currentLocaleId) async {
  final translator = GoogleTranslator();
  var translation = await translator.translate(lastWords,
      from: currentLocaleId.split("_")[0], to: 'en');
  return translation.toString();
}
