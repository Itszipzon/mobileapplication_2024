class ScoringSystem {
  final int singleSelectMaxPoints;
  final int multiSelectMaxPoints;

  ScoringSystem({
    this.singleSelectMaxPoints = 1000,
    this.multiSelectMaxPoints = 500,
  });

  int calculatePoints(int responseTime, int duration, int pointsPossible) {
    if (responseTime < 0.5) {
      return pointsPossible;
    }

    double reductionFactor = 1 - ((responseTime / duration) / 2);
    double finalPoints = pointsPossible * reductionFactor;

    return finalPoints.round();
  }
}
