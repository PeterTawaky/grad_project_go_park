import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/core/utils/theme/colors_manager.dart';
import 'package:smart_garage_final_project/logic/cubits/profile_cubit/profile_cubit.dart';

class ElevatorContainerWidget extends StatelessWidget {
  const ElevatorContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsetsDirectional.only(end: 20.w),
        padding: EdgeInsetsDirectional.only(start: 5.w),
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) => current is ElevatorDataLoaded,
          builder: (context, state) {
            if (state is ElevatorDataLoaded) {
              final data = state.elevatorData;
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 5.h,
                      bottom: 15.h,
                      start: 5.w,
                    ),
                    child: Column(
                      spacing: 4.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Elevator',
                          style: TextStyle(
                            color: ColorsManager.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          data.available ? 'available\nnow' : 'not\navailable',
                          style: TextStyle(
                            color: data.available ? Colors.teal : Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
                    child: Container(
                      height: double.infinity,
                      width: context.blockWidth * 14,
                      // width: context.blockWidth * 15.7142,
                      decoration: BoxDecoration(
                        color: ColorsManager.lightBlack,
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: Icon(
                        Icons.elevator_outlined,
                        size: 42.sp,
                        color: data.available ? Colors.teal : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: ColorsManager.authScreenPurple,
              ),
            );
          },
        ),
      ),
    );
  }
}
