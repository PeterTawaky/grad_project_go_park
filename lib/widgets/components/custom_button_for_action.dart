import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonForAction extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget centerWidget;
  final Color outlineColor;
  final Color backgroundColor;
  const CustomButtonForAction({
    super.key,
    required this.outlineColor,
    required this.backgroundColor,
    this.onPressed,
    required this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.r,
          ), // Adjust radius value for more or less rounding
        ),
        minimumSize: Size(
          double.infinity,
          50.h,
        ), // Sets minimum width and height
        backgroundColor: backgroundColor,
        side: BorderSide(color: outlineColor),
      ),
      onPressed: onPressed,
      child: centerWidget,
    );
  }
}