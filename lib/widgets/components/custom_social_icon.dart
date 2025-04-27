import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/core/utils/theme/colors_manager.dart';

class CustomSocialIcon extends StatelessWidget {
  final void Function()? onTap;
  final String image;
  const CustomSocialIcon({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: context.blockHeight * 6,
            width: context.blockHeight * 6,
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: BorderRadius.circular(200.r),
            ),
          ),
          Container(
            height: context.blockHeight * 5.7,
            width: context.blockHeight * 5.7,
            decoration: BoxDecoration(
              color: ColorsManager.authScreenBlack,
              borderRadius: BorderRadius.circular(200.r),
            ),
          ),
          Container(
            height: context.blockHeight * 3,
            width: context.blockHeight * 3,
            decoration: BoxDecoration(
              color: ColorsManager.authScreenBlack,
              borderRadius: BorderRadius.circular(200.r),
              image: DecorationImage(image: AssetImage(image)),
            ),
          ),
        ],
      ),
    );
  }
}
