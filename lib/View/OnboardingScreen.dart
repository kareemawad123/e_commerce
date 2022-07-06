import 'package:e_commerce/View/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OnboardingScreen extends StatefulWidget {
  final String? title;
  const OnboardingScreen({Key? key, this.title}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
      pages: pages,
      showBullets: true,
      skipCallback: () {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      },
      finishCallback: () {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      },
    ),
    );
  }

  final pages = [
    PageModel(
        color: const Color(0xFF0097A7),
        imageAssetPath: 'assets/splash_1.png',
        title: 'ShowShop',
        body: 'Welcome in ShowShop',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF536DFE),
        imageAssetPath: 'assets/splash_2.png',
        title: 'ShowShop',
        body: 'We help you to find your product',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF9B90BC),
        imageAssetPath: 'assets/splash_3.png',
        title: 'ShowShop',
        body: 'Shopping from your home',
        doAnimateImage: true),
  ];

  }

