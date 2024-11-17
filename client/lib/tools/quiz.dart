
class Quiz {
  String question;
  List<Option> options;

  Quiz({required this.question, required this.options});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      options: List<Option>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
    };
  }

  List<Option> getOptions() {
    return options;
  }

  String getQuestion() {
    return question;
  }

  void setQuestion(String question) {
    this.question = question;
  }

  void setOptions(List<Option> options) {
    this.options = options;
  }

  void addOption(Option option) {
    options.add(option);
  }
}

class Option {
  String optionText;
  bool isCorrect;

  Option({required this.optionText, this.isCorrect = false});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionText: json['optionText'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionText': optionText,
      'isCorrect': isCorrect,
    };
  }

  String getOption() {
    return optionText;
  }

  void setOption(String optionText) {
    this.optionText = optionText;
  }

  void setIsCorrect(bool isCorrect) {
    this.isCorrect = isCorrect;
  }

  bool getIsCorrect() {
    return isCorrect;
  }
}