import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 1800),
      () {
        Navigator.pushReplacementNamed(context, PagesRoutes.loginScreen);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInRightBig(child: Image.asset(ImageAssets.appLogo,
          scale: 1,)),
          FadeInLeft(
            child: Text(
              "Welcome To FCAI\n   Attendance System 👋",
              textAlign: TextAlign.center,
              style: getTextStyle(FontSize.s28, FontWeightManager.medium,
                  ColorsManager.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}
