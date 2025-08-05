import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_garage_final_project/logic/cubits/parking_timer_cubit/parking_timer_cubit.dart';
import 'app_routes.dart';
import '../../logic/cubits/authentication_cubit/authentication_cubit.dart';
import '../../logic/cubits/profile_cubit/profile_cubit.dart';
import '../../logic/cubits/parking_cubit/parking_cubit.dart';
import '../../login_screen.dart';
import '../../model/park_area_model.dart';
import '../../screens/create_account_screen.dart';
import '../../screens/go_park_screen.dart';
import '../../screens/local_authentication_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/splash_screen.dart';

class RouterGenerator {
  static GoRouter mainRouting = GoRouter(
    initialLocation: AppRoutes.splashScreen,

    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text('No Router for this app')));
    },
    routes: [
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder:
            (context, state) => BlocProvider<AuthenticationCubit>(
              create: (context) => AuthenticationCubit(),
              child: LoginScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.createAccountScreen,
        path: AppRoutes.createAccountScreen,
        builder: (context, state) {
          return BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(),
            child: CreateAccountScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.goParkScreen,
        path: AppRoutes.goParkScreen,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationCubit>(
                  create: (context) => AuthenticationCubit(),
                ),
                BlocProvider<ParkingCubit>(create: (context) => ParkingCubit()),
              ],
              child: GoParkingScreen(),
            ),
      ),
      GoRoute(
        name: AppRoutes.profileScreen,
        path: AppRoutes.profileScreen,
        builder: (context, state) {
          log(state.toString());
          return BlocProvider<ParkingTimerCubit>(
            create: (context) => ParkingTimerCubit(),
            child: ProfileScreen(parkArea: state.extra as ParkAreaModel),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.localAuthenticationScreen,
        path: AppRoutes.localAuthenticationScreen,
        builder: (context, state) => LocalAuthenticationScreen(),
      ),
    ],
  );
}
