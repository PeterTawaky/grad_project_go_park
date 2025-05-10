import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/app_validator.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../core/utils/theme/text_styles.dart';

class CustomTFF extends StatefulWidget {
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
  State<CustomTFF> createState() => _CustomTFFState();
}

class _CustomTFFState extends State<CustomTFF> {
  bool passwordHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.suffixIcon != null ? passwordHidden : false,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyles.font14regularWhite,
      validator: widget.validator,
      controller: widget.controller,
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
        prefixIcon: Icon(widget.prefixIcon, color: ColorsManager.white),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordHidden = !passwordHidden;
            });
          },
          icon: Icon(
            widget.suffixIcon != null
                ? passwordHidden
                    ? Icons.visibility_off
                    : Icons.visibility
                : null,
            color: ColorsManager.white,
          ),
        ),
        hintText: widget.hintText,
        labelText: widget.hintText,
        hintStyle: TextStyles.font14regularWhite,
      ),
    );
  }
}
