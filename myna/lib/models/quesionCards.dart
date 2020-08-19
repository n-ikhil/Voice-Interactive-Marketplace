import 'package:myna/services/gtranslator.dart';
import 'package:myna/speech/port.dart';

enum InputType { keyboard, audio }

class Question {
  String questionEnglish;
  String questionLanguage;
  InputType type;
  Question({language = "en_IN", this.questionEnglish, this.type}) {
    setLanguage(language);
  }

  Future setLanguage(language) async {
    if (language.startsWith("en")) {
      this.questionLanguage = this.questionEnglish;
      return;
    }
    await googleTranslateEnglishToSpecified(this.questionEnglish, language)
        .then((onValue) {
      questionLanguage = onValue;
    });
  }
}

class QuestionCard {
  List<String> fixedQuestions = [
    " What is the name of product you want to sell ",
    "What is the price of product you want to sell",
    " Is the product rentable "
  ];

  List<InputType> fixedTypes = [
    InputType.audio,
    InputType.audio,
    InputType.audio,
  ];

  List<Question> questions = [];
  String curLang = "en_IN";

  QuestionCard({this.curLang = 'en_IN'}) {
    for (int i = 0; i < fixedQuestions.length; i++) {
      Question q = Question(
          language: curLang,
          questionEnglish: fixedQuestions[i],
          type: fixedTypes[i]);
      questions.add(q);
    }
  }

  Future init(String languageCode) async {
    for (int i = 0; i < questions.length; i++) {
      await questions[i].setLanguage(languageCode);
    }
  }
}
