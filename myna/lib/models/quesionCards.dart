import 'package:myna/services/gtranslator.dart';

class Question {
  String questionEnglish;
  String questionLanguage;
  String type;
  String id;
  Question({language = "en_IN", data}) {
    questionEnglish = data[0];
    id = data[1];
    type = data[2];
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
      Question q = Question(language: curLang, data: fixedQuestions[i]);
      questions.add(q);
    }
  }

  Future init(String languageCode) async {
    for (int i = 0; i < questions.length; i++) {
      await questions[i].setLanguage(languageCode);
    }
  }
}
