import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_repository.dart';

class UpdateSubject {
  final SubjectRepository repo;

  const UpdateSubject(this.repo);

  Future<SubjectEntity> call(SubjectEntity subject) =>
      repo.updateSubject(subject);
}
