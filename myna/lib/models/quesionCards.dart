import 'package:myna/services/gtranslator.dart';

class Questions {
  List<String> questionStrings = [
    " What is the name of product you want to sell ",
    "What is the price of product you want to sell",
    " Is the product rentable "
  ];

  List<String> languageBased = [
    " What is the name of product you want to sell ",
    "What is the price of product you want to sell",
    " Is the product rentable "
  ];

  Future init(String languageCode) async {
    // languageCode.replaceAll("_IN", "");
    // languageCode = languageCode.split("_")[0];
    if (languageCode.startsWith("en")) {
      return;
    }

    await googleTranslatedtext(questionStrings[0], languageCode)
        .then((onValue) {
      languageBased[0] = onValue;
    });
    await googleTranslatedtext(questionStrings[1], languageCode)
        .then((onValue) {
      languageBased[1] = onValue;
    });
    await googleTranslatedtext(questionStrings[2], languageCode)
        .then((onValue) {
      languageBased[2] = onValue;
    });

    return;
  }
}
