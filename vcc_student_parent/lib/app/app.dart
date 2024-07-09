import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:vcc_student_parent/cubits/assignmentReportCubit.dart';
import 'package:vcc_student_parent/cubits/assignmentsCubit.dart';
import 'package:vcc_student_parent/cubits/childFeeDetailsCubit.dart';
import 'package:vcc_student_parent/cubits/onlineExamReportCubit.dart';
import 'package:vcc_student_parent/cubits/resultsOnlineCubit.dart';
import 'package:vcc_student_parent/cubits/schoolConfigurationCubit.dart';
import 'package:vcc_student_parent/data/repositories/assignmentRepository.dart';
import 'package:vcc_student_parent/data/repositories/feeRepository.dart';
import 'package:vcc_student_parent/data/repositories/resultRepository.dart';
import 'package:vcc_student_parent/data/repositories/schoolRepository.dart';
import 'package:vcc_student_parent/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:vcc_student_parent/app/appLocalization.dart';
import 'package:vcc_student_parent/app/routes.dart';

import 'package:vcc_student_parent/cubits/appConfigurationCubit.dart';
import 'package:vcc_student_parent/cubits/appLocalizationCubit.dart';
import 'package:vcc_student_parent/cubits/authCubit.dart';
import 'package:vcc_student_parent/cubits/examDetailsCubit.dart';
import 'package:vcc_student_parent/cubits/examsOnlineCubit.dart';
import 'package:vcc_student_parent/cubits/noticeBoardCubit.dart';
import 'package:vcc_student_parent/cubits/notificationSettingsCubit.dart';
import 'package:vcc_student_parent/cubits/postFeesPaymentCubit.dart';
import 'package:vcc_student_parent/cubits/reportTabSelectionCubit.dart';
import 'package:vcc_student_parent/cubits/resultTabSelectionCubit.dart';
import 'package:vcc_student_parent/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:vcc_student_parent/cubits/examTabSelectionCubit.dart';

import 'package:vcc_student_parent/data/repositories/announcementRepository.dart';
import 'package:vcc_student_parent/data/repositories/authRepository.dart';
import 'package:vcc_student_parent/data/repositories/onlineExamRepository.dart';
import 'package:vcc_student_parent/data/repositories/settingsRepository.dart';
import 'package:vcc_student_parent/data/repositories/studentRepository.dart';
import 'package:vcc_student_parent/data/repositories/systemInfoRepository.dart';

import 'package:vcc_student_parent/cubits/onlineExamQuestionsCubit.dart';
import 'package:vcc_student_parent/data/repositories/reportRepository.dart';
import 'package:vcc_student_parent/ui/styles/colors.dart';

import 'package:vcc_student_parent/utils/appLanguages.dart';
import 'package:vcc_student_parent/utils/hiveBoxKeys.dart';
import 'package:vcc_student_parent/utils/notificationUtility.dart';
import 'package:vcc_student_parent/utils/utils.dart';

//to avoid handshake error on some devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  //Register the licence of font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationUtility.initializeAwesomeNotification();

  await Hive.initFlutter();
  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(authBoxKey);
  await Hive.openBox(notificationsBoxKey);
  await Hive.openBox(settingsBoxKey);
  await Hive.openBox(studentSubjectsBoxKey);

  runApp(const MyApp());
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationUtility.onDismissActionReceivedMethod,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //preloading some of the imaegs
    precacheImage(
      AssetImage(Utils.getImagePath("upper_pattern.png")),
      context,
    );

    precacheImage(
      AssetImage(Utils.getImagePath("lower_pattern.png")),
      context,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<NotificationSettingsCubit>(
          create: (_) => NotificationSettingsCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<StudentSubjectsAndSlidersCubit>(
          create: (_) => StudentSubjectsAndSlidersCubit(),
        ),
        BlocProvider<NoticeBoardCubit>(
          create: (context) => NoticeBoardCubit(AnnouncementRepository()),
        ),
        BlocProvider<AppConfigurationCubit>(
          create: (context) => AppConfigurationCubit(SystemRepository()),
        ),
        BlocProvider<ExamDetailsCubit>(
          create: (context) => ExamDetailsCubit(StudentRepository()),
        ),
        BlocProvider<PostFeesPaymentCubit>(
          create: (context) => PostFeesPaymentCubit(StudentRepository()),
        ),
        BlocProvider<ResultTabSelectionCubit>(
          create: (_) => ResultTabSelectionCubit(),
        ),
        BlocProvider<ReportTabSelectionCubit>(
          create: (_) => ReportTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamReportCubit>(
          create: (_) => OnlineExamReportCubit(ReportRepository()),
        ),
        BlocProvider<AssignmentReportCubit>(
          create: (_) => AssignmentReportCubit(ReportRepository()),
        ),
        BlocProvider<ExamTabSelectionCubit>(
          create: (_) => ExamTabSelectionCubit(),
        ),
        BlocProvider<OnlineExamQuestionsCubit>(
          create: (_) => OnlineExamQuestionsCubit(OnlineExamRepository()),
        ),
        BlocProvider<ExamsOnlineCubit>(
          create: (_) => ExamsOnlineCubit(OnlineExamRepository()),
        ),
        BlocProvider<ResultsOnlineCubit>(
          create: (_) => ResultsOnlineCubit(ResultRepository()),
        ),
        BlocProvider<AssignmentsCubit>(
          create: (_) => AssignmentsCubit(AssignmentRepository()),
        ),
        BlocProvider<SchoolConfigurationCubit>(
            create: (_) => SchoolConfigurationCubit(SchoolRepository())),
        BlocProvider<ChildFeeDetailsCubit>(
            create: (_) => ChildFeeDetailsCubit(FeeRepository()))
      ],
      child: Builder(
        builder: (context) {
          final currentLanguage =
              context.watch<AppLocalizationCubit>().state.language;

          return MaterialApp(
            navigatorKey: Utils.rootNavigatorKey,
            theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: onPrimaryColor,
                    secondary: secondaryColor,
                    surface: backgroundColor,
                    error: errorColor,
                    onSecondary: onSecondaryColor,
                    onSurface: onBackgroundColor,
                  ),
            ),
            builder: (context, widget) {
              return ScrollConfiguration(
                behavior: GlobalScrollBehavior(),
                child: widget!,
              );
            },
            locale: currentLanguage,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: appLanguages.map((appLanguage) {
              return Utils.getLocaleFromLanguageCode(
                appLanguage.languageCode,
              );
            }).toList(),
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            onGenerateRoute: Routes.onGenerateRouted,
          );
        },
      ),
    );
  }
}
