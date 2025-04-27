import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_garage_final_project/core/utils/app_strings.dart';
import 'package:smart_garage_final_project/core/utils/app_validator.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/logic/provider/form_input.dart';
import 'package:smart_garage_final_project/widgets/components/custom_tff.dart';

class FieldsSectionLoginScreen extends StatelessWidget {
  FieldsSectionLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<FormInput>().validateKey,
      child: Column(
        children: [
          CustomTFF(
            validator:
                (value) => AppValidator.validateEmailCreation(
                  value,
                ), // Pass the current value
            // validator: AppValidator.validateEmail(
            //   context.read<FormInput>().emailController.text,
            // ),
            controller:
                context
                    .read<FormInput>()
                    .emailController, // a value in the FormInput
            hintText: AppStrings.email,
            prefixIcon: CupertinoIcons.person_fill,
          ),
          SizedBox(height: context.blockHeight * 1),
          CustomTFF(
            validator: (value) => AppValidator.validatePasswordSignIn(value),
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
