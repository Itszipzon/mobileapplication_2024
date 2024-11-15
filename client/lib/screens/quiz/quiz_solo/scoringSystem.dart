class ScoringSystem {
  final int singleSelectMaxPoints;
  final int multiSelectMaxPoints;

  ScoringSystem({
    this.singleSelectMaxPoints = 1000,
    this.multiSelectMaxPoints = 500,
  });

  /// Calculate the points based on response time.
  int calculatePoints(int responseTime, int duration, int pointsPossible) {
    if (responseTime < 0.5) {
      return pointsPossible;
    }

    double reductionFactor = 1 - ((responseTime / duration) / 2);
    double finalPoints = pointsPossible * reductionFactor;

    return finalPoints.round();
  }

  /// Calculate the final score based on correct/incorrect answers.
  int calculateFinalScore(List<dynamic> questionScores, List<dynamic> checks,
      Map<String, dynamic> quizData) {
    int finalScore = 0;

    for (int i = 0; i < questionScores.length; i++) {
      final questionId = quizData["quizQuestions"][i]["id"];
      final answerCorrect = checks.any((check) =>
          check["questionId"] == questionId && check["correct"] == true);

      if (answerCorrect) {
        finalScore += (questionScores[i] as num).toInt();
      }
    }

    return finalScore;
  }
}
