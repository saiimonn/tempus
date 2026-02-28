class ScoresEntity {
  final int id;
  final String title;
  final double scoreValue;
  final double maxScore;

  const ScoresEntity({
    required this.id,
    required this.title,
    required this.scoreValue,
    required this.maxScore,
  });

  double get percent => maxScore > 0 ? scoreValue : 0;
}