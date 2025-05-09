import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/size_config.dart';
import 'core/utils/theme/colors_manager.dart';
import 'core/utils/theme/fonts_manager.dart';

class LoggingWidget extends StatelessWidget {
  final String loggingMessage;
  const LoggingWidget({super.key, required this.loggingMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.blockHeight * 100,
      width: context.blockWidth * 100,
      color: ColorsManager.lightBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            loggingMessage,
            style: TextStyle(
              color: ColorsManager.white,
              fontSize: 20.sp,
              fontFamily: FontsManager.stinger,
            ),
          ),
          SizedBox(height: 28.h),
          CircularProgressIndicator(color: ColorsManager.authScreenPurple),
        ],
      ),
    );
  }
}
