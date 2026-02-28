import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';

class ScoreModel extends ScoresEntity {
  const ScoreModel({
    required super.id,
    required super.title,
    required super.scoreValue,
    required super.maxScore,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] as int,
      title: map['title'] as String,
      scoreValue: (map['score_value'] as num).toDouble(),
      maxScore: (map['max_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'score_value': scoreValue,
      'max_score': maxScore,
    };
  }
}