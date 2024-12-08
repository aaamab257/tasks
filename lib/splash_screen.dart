import 'package:flutter/material.dart';
import 'components/widgets.dart';
import 'routes/pages.dart';
import 'utils/color_palette.dart';
import 'utils/font_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() async {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushNamed(context, Pages.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            buildText('Task Manager', kWhiteColor, textBold, FontWeight.w600,
                TextAlign.center, TextOverflow.clip),
            const SizedBox(
              height: 10,
            ),
            buildText('Organize your time for your tasks', kWhiteColor, textTiny,
                FontWeight.normal, TextAlign.center, TextOverflow.clip),
          ],
        )));
  }
}
