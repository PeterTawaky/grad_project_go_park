import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:smart_garage_final_project/logic/cubits/profile_cubit/profile_cubit.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../core/utils/theme/fonts_manager.dart';
import '../../logic/cubits/parking_cubit/parking_cubit.dart';

class SlideActionButton extends StatelessWidget {
  const SlideActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Builder(
      builder: (context) {
        final GlobalKey<SlideActionState> key = GlobalKey();
        return SlideAction(
          submittedIcon: Icon(Icons.bolt, color: ColorsManager.sky),
          sliderButtonIconPadding: 25.h,
          sliderButtonYOffset: -4.w,
          key: key,
          outerColor: Colors.white.withOpacity(0.1),
          innerColor: ColorsManager.grey,
          sliderButtonIcon: Icon(Icons.bolt, color: ColorsManager.white),
          onSubmit: () {
            BlocProvider.of<ProfileCubit>(context).setInitialImage();
            BlocProvider.of<ParkingCubit>(context).startParkingProcess();
            return null;
          },
          borderRadius: 22,
          height: height * 0.11,
          animationDuration: Duration(seconds: 1),
          child: Row(
            children: [
              SizedBox(width: width * 0.3),
              Text(
                'Start Parking',
                style: TextStyle(
                  fontSize: 22,
                  color: ColorsManager.white,
                  fontFamily: FontsManager.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(flex: 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '>',
                      style: TextStyle(
                        fontSize: 32,
                        color: ColorsManager.white,
                        fontFamily: FontsManager.poppins,
                      ),
                    ),
                    TextSpan(
                      text: '>',
                      style: TextStyle(
                        fontSize: 32,
                        color: ColorsManager.white.withValues(alpha: 0.6),
                        fontFamily: FontsManager.poppins,
                      ),
                    ),
                    TextSpan(
                      text: '>',
                      style: TextStyle(
                        fontSize: 32,
                        color: ColorsManager.white.withValues(alpha: 0.3),
                        fontFamily: FontsManager.poppins,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
