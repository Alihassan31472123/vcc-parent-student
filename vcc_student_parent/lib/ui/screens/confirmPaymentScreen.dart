import 'package:vcc_student_parent/app/routes.dart';
import 'package:vcc_student_parent/cubits/childFeeDetailsCubit.dart';
import 'package:vcc_student_parent/ui/widgets/customAppbar.dart';
import 'package:vcc_student_parent/ui/widgets/customRoundedButton.dart';
import 'package:vcc_student_parent/utils/labelKeys.dart';
import 'package:vcc_student_parent/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  ConfirmPaymentScreen({Key? key}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => ConfirmPaymentScreen(),
    );
  }

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ChildFeeDetailsCubit>().refreshFees();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Routes.currentRoute = Routes.previousRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Utils.screenContentHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                    Utils.getLottieAnimationPath("verify_process.json")),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  Utils.getTranslatedLabel(
                      context, youCanCloseTheAppOrScreenKey),
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  Utils.getTranslatedLabel(context, willNotifyYouKey),
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    CustomRoundedButton(
                      height: 40,
                      widthPercentage: 0.4,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: goBackKey,
                      showBorder: false,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    CustomRoundedButton(
                      height: 40,
                      widthPercentage: 0.4,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: homeKey,
                      showBorder: false,
                      onTap: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: CustomAppBar(
            title: Utils.getTranslatedLabel(context, paymentConfirmationKey),
          ),
        ),
      ],
    ));
  }
}
