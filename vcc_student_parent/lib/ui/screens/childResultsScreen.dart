import 'package:vcc_student_parent/cubits/resultsCubit.dart';
import 'package:vcc_student_parent/data/models/subject.dart';
import 'package:vcc_student_parent/data/repositories/studentRepository.dart';
import 'package:vcc_student_parent/ui/widgets/resultsContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildResultsScreen extends StatelessWidget {
  final int childId;
  final List<Subject>? subjects;
  const ChildResultsScreen({
    Key? key,
    required this.childId,
    required this.subjects,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<ResultsCubit>(
        create: (context) => ResultsCubit(StudentRepository()),
        child: ChildResultsScreen(
          childId: arguments['childId'],
          subjects: arguments['subjects'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResultsContainer(
        childId: childId,
        subjects: subjects,
      ),
    );
  }
}
