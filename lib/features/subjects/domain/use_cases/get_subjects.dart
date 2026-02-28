import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_repository.dart';

class GetSubjects{
  final SubjectRepository repo;

  const GetSubjects(this.repo);

  Future<List<SubjectEntity>> call() => repo.getSubjects();
}