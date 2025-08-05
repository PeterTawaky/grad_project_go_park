import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/size_config.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../logic/cubits/profile_cubit/profile_cubit.dart';

class ElevatorContainerWidget extends StatefulWidget {
  const ElevatorContainerWidget({super.key});

  @override
  State<ElevatorContainerWidget> createState() =>
      _ElevatorContainerWidgetState();
}

class _ElevatorContainerWidgetState extends State<ElevatorContainerWidget> {
  late StreamSubscription<DatabaseEvent> _elevatorSubscription;
  int realTimeValue = 0;
  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      'isElevatorAvailable',
    );
    _elevatorSubscription = ref.onValue.listen((event) {
      if (mounted) {
        setState(() {
          realTimeValue = event.snapshot.value as int;
        });
      }
    });
  }

  @override
  void dispose() {
    _elevatorSubscription.cancel();
    super.dispose();
  }

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
        child: Row(
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
                    //!!!!!!!!!!!!!!!!!
                    realTimeValue == 1 ? 'available\nnow' : 'not\navailable',
                    style: TextStyle(
                      color: realTimeValue == 1 ? Colors.teal : Colors.red,
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
                  color: realTimeValue == 1 ? Colors.teal : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
