import 'package:client/tools/api_handler.dart';

class QuizAnswerManager {
  final List<Map<String, int?>> userAnswers = [];

  void recordAnswer(Map<String, dynamic> quizData, int currentQuestionIndex,
      String selectedAnswer) {
    final questionId = quizData["quizQuestions"][currentQuestionIndex]["id"];
    final selectedOption = quizData["quizQuestions"][currentQuestionIndex]
            ["quizOptions"]
        .firstWhere((option) => option["option"] == selectedAnswer)["id"];
    userAnswers.add({"questionId": questionId, "answerId": selectedOption});
  }

  void saveUnanswered(Map<String, dynamic> quizData, int currentQuestionIndex) {
    userAnswers.add({
      "questionId": quizData["quizQuestions"][currentQuestionIndex]["id"],
      "answerId": null,
    });
  }

  Future<Map<String, dynamic>> submitAnswers(String token, int quizId) async {
    return ApiHandler.playQuiz(token, quizId, userAnswers);
  }
}
