import 'package:myna/services/gtranslator.dart';

class Question {
  String questionEnglish;
  String questionLanguage;
  String type;
  String id;
  bool questionLoaded;
  Question();
  QuestionSet({language = "en_IN", data}) async {
    questionEnglish = data[0];
    questionLanguage = data[0];
    questionLoaded = false;
    id = data[1];
    type = data[2];
    await setLanguage(language);
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
    this.questionLoaded = true;
  }
}

class QuestionCard {
  // basically [string,id]
  List<List<String>> fixedQuestions = [
    [" What is the name of product you want to sell ", "productID", "audio"],
    ["What is the price of product you want to sell", "price", "keyPad"],
    ["Please enter your contact number to call ", "contact", "keyPad"],
    [
      "Please give some brief Description of the product ",
      "description",
      "audio"
    ],
    [" Will you be able to rent the product  ", "isRentable", "boolButton"],
    [
      "please add some images",
      "imgURL",
      "file",
    ]
  ];

  List<Question> questions = [];
  String curLang = "en_IN";

  QuestionCard({this.curLang = 'en_IN'}) {
    for (int i = 0; i < fixedQuestions.length; i++) {
      Question q = Question();
      questions.add(q);
    }
  }

  QuestionCardSet() async {
    for (int i = 0; i < fixedQuestions.length; i++) {
      await questions[i]
          .QuestionSet(language: curLang, data: fixedQuestions[i]);
    }
  }

  Future init(String languageCode) async {
    for (int i = 0; i < questions.length; i++) {
      await questions[i].setLanguage(languageCode);
    }
  }
}
