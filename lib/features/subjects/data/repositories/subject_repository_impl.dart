import 'package:tempus/features/subjects/data/data_source/subject_local_data_source.dart';
import 'package:tempus/features/subjects/data/models/subject_model.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectLocalDataSource dataSource;

  const SubjectRepositoryImpl(this.dataSource);

  @override
  Future <List<SubjectEntity>> getSubjects() => dataSource.getSubjects();

  @override
  Future<SubjectEntity> addSubject(SubjectEntity subject) {
    final model = SubjectModel(
      id: subject.id,
      name: subject.name,
      code: subject.code,
      instructor: subject.instructor,
      units: subject.units,
      grades: subject.grades,
    );
    return dataSource.addSubject(model);
  }
}