import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/size_config.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../logic/cubits/parking_timer_cubit/parking_timer_cubit.dart';
import '../../logic/cubits/parking_timer_cubit/parking_timer_state.dart';

class FeesContainerWidget extends StatelessWidget {
  const FeesContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingTimerCubit, ParkingTimerState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.only(end: 20.w),

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: ColorsManager.lightBlack,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
                  child: Container(
                    height: double.infinity,
                    width: context.blockWidth * 15.7142,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: Icon(Icons.attach_money, size: 35),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 5.h,
                    bottom: 15.h,
                    start: 10.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'fees',
                        style: TextStyle(
                          color: ColorsManager.grey,
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        '${state.price.toInt()}',
                        style: TextStyle(
                          color: ColorsManager.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}