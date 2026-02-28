import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';

abstract class SubjectRepository {
  Future <List<SubjectEntity>> getSubjects();
  Future <SubjectEntity> addSubject(SubjectEntity subject);
}