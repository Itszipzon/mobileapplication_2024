import 'dart:io';

class Quiz {
  String question;
  List<Option> options;
  File? imageFile;

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
  String option;
  bool isCorrect;

  Option({required this.option, this.isCorrect = false});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      option: json['option'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'isCorrect': isCorrect,
    };
  }

  String getOption() {
    return option;
  }

  void setOption(String option) {
    this.option = option;
  }

  void setIsCorrect(bool isCorrect) {
    this.isCorrect = isCorrect;
  }

  bool getIsCorrect() {
    return isCorrect;
  }
}