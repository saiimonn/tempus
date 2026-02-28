import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_repository.dart';

class AddSubject {
  final SubjectRepository repo;

  const AddSubject(this.repo);

  Future <SubjectEntity> call(SubjectEntity subject) => repo.addSubject(subject);
}