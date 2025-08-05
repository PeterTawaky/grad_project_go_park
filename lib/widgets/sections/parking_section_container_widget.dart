import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/app_assets.dart';
import '../../core/utils/size_config.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../core/utils/theme/text_styles.dart';

class ParkingSectionContainerWidget extends StatelessWidget {
  final String areaId;
  const ParkingSectionContainerWidget({super.key, required this.areaId});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 20.w),
              padding: EdgeInsetsDirectional.only(top: 15.h, start: 20.w),

              decoration: BoxDecoration(
                color: ColorsManager.yellow,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'section',
                    style: TextStyle(
                      color: ColorsManager.grey,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    areaId,
                    style: TextStyles.font25BoldWhite.copyWith(
                      letterSpacing: 3,
                      color: ColorsManager.black,
                      fontSize: 34.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 60.h,
            right: -20.w,
            child: Image.asset(
              Assets.imagesBmwCarWithoutBackground,
              width: context.blockWidth * 50,
              height: context.blockHeight * 30,
            ),
          ),
        ],
      ),
    );
  }
}
