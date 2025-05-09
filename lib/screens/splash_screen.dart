import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/theme/colors_manager.dart';
import '../login_screen.dart';
import 'local_authentication_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 5),
      () => context.pushReplacementNamed(AppRoutes.localAuthenticationScreen),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.animationColor,
      body: Center(
        child: Lottie.asset('assets/animation/splash_animation.json'),
      ),
    );
  }
}
