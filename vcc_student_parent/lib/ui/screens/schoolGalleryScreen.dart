import 'package:vcc_student_parent/cubits/schoolGalleryCubit.dart';
import 'package:vcc_student_parent/cubits/schoolSessionYearsCubit.dart';

import 'package:vcc_student_parent/data/models/student.dart';
import 'package:vcc_student_parent/data/repositories/schoolRepository.dart';

import 'package:vcc_student_parent/ui/widgets/schoolGalleryWithSessionYearFilterContainer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolGalleryScreen extends StatelessWidget {
  final Student student;
  SchoolGalleryScreen({Key? key, required this.student}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SchoolGalleryCubit(SchoolRepository()),
          ),
          BlocProvider(
            create: (context) => SchoolSessionYearsCubit(SchoolRepository()),
          ),
        ],
        child: SchoolGalleryScreen(
          student: routeSettings.arguments as Student,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolGalleryWithSessionYearFilterContainer(
          showBackButton: true, student: student),
    );
  }
}
