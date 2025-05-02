import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_garage_final_project/core/utils/app_validator.dart';
import 'package:smart_garage_final_project/core/utils/theme/colors_manager.dart';
import 'package:smart_garage_final_project/core/utils/theme/text_styles.dart';

class CustomTFF extends StatelessWidget {
  final String? hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomTFF({
    super.key,
    required this.prefixIcon,
    this.hintText,
    this.suffixIcon,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyles.font14regularWhite,
      validator: validator,
      controller: controller,
      onChanged: (value) {
        double _passwordStrength = AppValidator.calculatePasswordStrength(
          value,
        );
        log(_passwordStrength.toString());
      },
      decoration: InputDecoration(
        errorMaxLines: 3,
        contentPadding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        prefixIcon: Icon(prefixIcon, color: ColorsManager.white),
        suffixIcon: Icon(suffixIcon, color: ColorsManager.white),
        hintText: hintText,
        labelText: hintText,
        hintStyle: TextStyles.font14regularWhite,
      ),
    );
  }
}
