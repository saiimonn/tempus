import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';

class GradeCategoryModel extends GradeCategoryEntity{
  const GradeCategoryModel({
    required super.id,
    required super.name,
    required super.weight,
  });

  factory GradeCategoryModel.fromMap(Map<String, dynamic> map) {
    return GradeCategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      weight: (map['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'weight': weight};
  }
}