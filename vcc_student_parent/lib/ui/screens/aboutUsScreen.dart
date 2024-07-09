import 'package:vcc_student_parent/cubits/appSettingsCubit.dart';
import 'package:vcc_student_parent/data/repositories/systemInfoRepository.dart';
import 'package:vcc_student_parent/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:vcc_student_parent/ui/widgets/customAppbar.dart';
import 'package:vcc_student_parent/utils/labelKeys.dart';
import 'package:vcc_student_parent/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<AppSettingsCubit>(
        create: (context) => AppSettingsCubit(SystemRepository()),
        child: const AboutUsScreen(),
      ),
    );
  }
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final String aboutUsType = "about_us";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<AppSettingsCubit>().fetchAppSettings(type: aboutUsType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppSettingsBlocBuilder(appSettingsType: aboutUsType),
          CustomAppBar(title: Utils.getTranslatedLabel(context, aboutUsKey))
        ],
      ),
    );
  }
}
