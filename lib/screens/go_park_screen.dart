import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_garage_final_project/logic/blocs/internet_bloc/internet_bloc.dart';
import 'package:smart_garage_final_project/screens/no_internet_widget.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/app_assets.dart';
import '../core/utils/app_strings.dart';
import '../core/utils/helper/helper_functions.dart';
import '../core/utils/size_config.dart';

import '../core/utils/theme/colors_manager.dart';
import '../logic/cubits/parking_cubit/parking_cubit.dart';
import '../widgets/components/slide_action_button.dart';
import '../core/utils/theme/fonts_manager.dart';
import '../logic/cubits/authentication_cubit/authentication_cubit.dart';
import '../logging_widget.dart';

class GoParkingScreen extends StatelessWidget {
  const GoParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<InternetBloc, InternetState>(
        builder: (context, state) {
          if (state is NotConnectedState) {
            return NoInternetWidget();
          } else {
            return BlocConsumer<AuthenticationCubit, AuthenticationState>(
              buildWhen:
                  (previous, current) =>
                      current is LoggingOutLoading ||
                      current is LoggingOutSuccess,
              listener: (context, state) {
                if (state is LoggingOutSuccess) {
                  context.pushReplacementNamed(AppRoutes.loginScreen);
                }
              },
              builder: (context, state) {
                if (state is LoggingOutLoading) {
                  return LoggingWidget(
                    loggingMessage: AppStrings.signOutLogging,
                  );
                } else {
                  return BlocListener<ParkingCubit, ParkingState>(
                    listener: (context, state) {
                      if (state is ParkingProcessSuccess) {
                        context.pushReplacementNamed(
                          AppRoutes.profileScreen,
                          extra: state.parkArea,
                        );
                      } else if (state is ParkingProcessFaild) {
                        HelperFunctions.showSnackBar(
                          msg: state.message,
                          context: context,
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesCarCover),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        top: 20.h,
                                      ),
                                      child: Text(
                                        'GoPark',
                                        style: TextStyle(
                                          color: ColorsManager.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontsManager.stinger,
                                          fontSize: 28.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      start: 16.w,
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'MAKE YOUR',
                                            style: TextStyle(
                                              color: ColorsManager.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\nPARKING ',
                                            style: TextStyle(
                                              color: ColorsManager.sky,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'SMART \nAND EASY.',
                                            style: TextStyle(
                                              color: ColorsManager.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  SlideActionButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: context.blockHeight,
                          right: 16.w,
                          child: IconButton(
                            onPressed: () {
                              BlocProvider.of<AuthenticationCubit>(
                                context,
                              ).signOut();
                            },
                            icon: Icon(
                              Icons.logout,
                              color: ColorsManager.white,
                              size: 26.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
