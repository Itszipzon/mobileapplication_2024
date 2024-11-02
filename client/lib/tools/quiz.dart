class Quiz {
  String question;
  List<String> options;
  bool isCorrect;

  Quiz({required this.question, required this.options, this.isCorrect = false});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      options: List<String>.from(json['options']),
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'isCorrect': isCorrect,
    };
  }

  List<String> getOptions() {
    return options;
  }

  String getQuestion() {
    return question;
  }

  void setQuestion(String question) {
    this.question = question;
  }

  void setOptions(List<String> options) {
    this.options = options;
  }

  void setIsCorrect(bool isCorrect) {
    this.isCorrect = isCorrect;
  }

  bool getIsCorrect() {
    return isCorrect;
  }
}