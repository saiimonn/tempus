import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/data_source/subject_remote_data_source.dart';
import 'package:tempus/features/subjects/data/models/subject_model.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource dataSource;

  const SubjectRepositoryImpl(this.dataSource);

  factory SubjectRepositoryImpl.create() =>
      SubjectRepositoryImpl(SubjectRemoteDataSource(Supabase.instance.client));

  @override
  Future<List<SubjectEntity>> getSubjects() => dataSource.getSubjects();

  @override
  Future<SubjectEntity> addSubject(SubjectEntity subject) {
    final model = SubjectModel(
      id: subject.id,
      name: subject.name,
      code: subject.code,
      instructor: subject.instructor,
      units: subject.units,
    );
    return dataSource.addSubject(model);
  }

  @override
  Future<SubjectEntity> updateSubject(SubjectEntity subject) {
    final model = SubjectModel(
      id: subject.id,
      name: subject.name,
      code: subject.code,
      instructor: subject.instructor,
      units: subject.units,
    );
    return dataSource.updateSubject(model);
  }
}
