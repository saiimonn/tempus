import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_detail_repository.dart';

class GetSubjectDetail {
  final SubjectDetailRepository repo;

  const GetSubjectDetail(this.repo);

  Future <SubjectDetailEntity> call(dynamic subjectId) => repo.getSubjectDetail(subjectId); 
}