import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_garage_final_project/logic/blocs/internet_bloc/internet_bloc.dart';
import 'package:smart_garage_final_project/logic/cubits/profile_cubit/profile_cubit.dart';
import '../core/routes/router_generator.dart';
import '../core/utils/theme/app_theme_data.dart';

class SmartGarage extends StatelessWidget {
  const SmartGarage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit()..setInitialImage(),
      child: ScreenUtilInit(
        designSize: const Size(
          360,
          690,
        ), //the size of screen that designer work on it on figma
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocProvider<InternetBloc>(
            create: (context) => InternetBloc(),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Smart Garage',
              theme: AppThemeData.darkTheme,
              routerConfig: RouterGenerator.mainRouting,
            ),
          );
        },
      ),
    );
  }
}
