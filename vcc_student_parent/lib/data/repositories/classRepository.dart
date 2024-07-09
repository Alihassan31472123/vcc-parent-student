import 'package:vcc_student_parent/data/models/electiveSubjectGroup.dart';
import 'package:vcc_student_parent/utils/api.dart';

class ClassRepository {
  Future<List<ElectiveSubjectGroup>> getElectiveSubjects() async {
    try {
      final result = await Api.get(url: Api.classSubjects, useAuthToken: true);

      final electiveSubjectGroups =
          result['data']['elective_subject_group'] as List;

      return electiveSubjectGroups
          .map((json) => ElectiveSubjectGroup.fromJson(Map.from(json ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
