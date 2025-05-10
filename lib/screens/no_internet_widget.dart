import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/core/utils/theme/colors_manager.dart';
import 'package:smart_garage_final_project/core/utils/theme/text_styles.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: context.blockWidth * 80,
            height: context.blockHeight * 30,
            child: Lottie.asset('assets/animation/no_internet_animation.json'),
          ),
          Text('Ooops!', style: TextStyles.font46regularPurple),
          SizedBox(height: context.blockHeight * 4),
          Text(
            'Slow or no internet connection\ncheck your internet connection',
            style: TextStyles.font14BoldWhite,
          ),
          SizedBox(height: context.blockHeight * 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.authScreenPurple,
            ),
            onPressed: () {},
            child: Text('TRY AGAIN', style: TextStyles.font14BoldWhite),
          ),
        ],
      ),
    );
  }
}
