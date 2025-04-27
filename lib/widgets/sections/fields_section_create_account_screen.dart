import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_garage_final_project/core/utils/app_strings.dart';
import 'package:smart_garage_final_project/core/utils/app_validator.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/logic/provider/form_input.dart';
import 'package:smart_garage_final_project/widgets/components/custom_tff.dart';

class FieldsSectionCreateAccountScreen extends StatelessWidget {
  const FieldsSectionCreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<FormInput>().validateKey,
      child: Column(
        children: [
          CustomTFF(
            validator: (value) => AppValidator.validateName(value),
            controller: context.read<FormInput>().nickNameController,
            hintText: AppStrings.nickName,
            prefixIcon: CupertinoIcons.person_fill,
          ),
          SizedBox(height: context.blockHeight * 1),

          CustomTFF(
            validator: (value) => AppValidator.validateEmailCreation(value),
            controller: context.read<FormInput>().emailController,
            hintText: AppStrings.email,
            prefixIcon: CupertinoIcons.person_fill,
          ),
          SizedBox(height: context.blockHeight * 1),
          CustomTFF(
            validator: (value) => AppValidator.validatePasswordCreation(value),
            controller: context.read<FormInput>().passwordController,
            hintText: AppStrings.password,
            prefixIcon: Icons.lock,
            suffixIcon: Icons.remove_red_eye,
          ),
        ],
      ),
    );
  }
}