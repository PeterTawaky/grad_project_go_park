import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/app_assets.dart';
import '../core/utils/app_strings.dart';
import '../core/utils/app_validator.dart';
import '../core/utils/helper/helper_functions.dart';
import '../core/utils/size_config.dart';
import '../core/utils/theme/colors_manager.dart';
import '../core/utils/theme/text_styles.dart';
import '../firebase/firebase_auth_consumer.dart';
import '../logging_widget.dart';
import '../logic/cubits/authentication_cubit/authentication_cubit.dart';
import '../logic/provider/form_input.dart';
import '../login_screen.dart';
import '../widgets/components/custom_button_for_action.dart';
import '../widgets/components/custom_social_icon.dart';
import '../widgets/sections/fields_section_create_account_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FormInput formInput = FormInput();
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          buildWhen:
              (previous, current) =>
                  current is GoogleSignInLoading ||
                  current is GoogleSignInSuccess ||
                  current is GoogleSignInFailed ||
                  current is FacebookSignInLoading ||
                  current is FacebookSignInSuccess ||
                  current is FacebookSignInFailed,
          listener: (context, state) {
            if (state is GoogleSignInSuccess ||
                state is FacebookSignInSuccess) {
              context.pushReplacementNamed(AppRoutes.goParkScreen);
            } else if (state is GoogleSignInFailed) {
              if (state.errorMessage != null && state.errorMessage != 'false') {
                log(state.errorMessage.runtimeType.toString());
                HelperFunctions.showSnackBar(
                  msg: state.errorMessage!,
                  context: context,
                );
              }
            } else if (state is FacebookSignInFailed) {
              if (state.errorMessage != null && state.errorMessage != 'false') {
                log(state.errorMessage.runtimeType.toString());
                HelperFunctions.showSnackBar(
                  msg: state.errorMessage!,
                  context: context,
                );
              }
            }
          },
          builder: (context, state) {
            if (state is GoogleSignInLoading ||
                state is FacebookSignInLoading) {
              return LoggingWidget(loggingMessage: AppStrings.signInLogging);
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: context.blockWidth * 8,
                      end: context.blockWidth * 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          highlightColor: ColorsManager.authScreenGrey,
                          icon: Icon(
                            size: 40.sp,
                            Icons.arrow_back_ios_new,
                            color: ColorsManager.white,
                          ),
                          onPressed: () {
                            context.pop();
                          },
                        ),

                        SizedBox(height: context.blockHeight * 1),
                        Text(
                          AppStrings.letsCreateYourAccount,
                          style: TextStyles.font25BoldWhite,
                        ),
                        Center(
                          child: ClipOval(
                            child: Image.asset(
                              Assets
                                  .imagesNnnRemovebgPreview, // Change to your image path
                              width: 150.w, // Adjust size
                              height: 150.w,
                              fit:
                                  BoxFit
                                      .cover, // Ensures the image fills the oval
                            ),
                          ),
                        ),
                        Provider.value(
                          value: formInput,
                          child: FieldsSectionCreateAccountScreen(),
                        ),

                        SizedBox(height: context.blockHeight * 0.5),

                        BlocConsumer<AuthenticationCubit, AuthenticationState>(
                          listener: (context, state) {
                            if (state is AuthenticationSuccess) {
                              HelperFunctions.showSnackBar(
                                context: context,
                                msg: state.message!,
                              );
                              context.pushNamed(AppRoutes.loginScreen);
                            } else if (state is AuthenticationError) {
                              if (state.errorMessage != null) {
                                HelperFunctions.showSnackBar(
                                  context: context,
                                  msg: state.errorMessage!,
                                );
                              }
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthenticationLoading) {
                              return CustomButtonForAction(
                                centerWidget: CircularProgressIndicator(
                                  color: ColorsManager.white,
                                ),
                                backgroundColor: ColorsManager.authScreenPurple,
                                outlineColor: ColorsManager.authScreenPurple,
                              );
                            } else {
                              return CustomButtonForAction(
                                centerWidget: Text(
                                  AppStrings.createAccount,
                                  style: TextStyles.font14BoldWhite,
                                ),
                                backgroundColor: ColorsManager.authScreenPurple,
                                outlineColor: ColorsManager.authScreenPurple,
                                onPressed: () {
                                  if (formInput.validateKey.currentState!
                                      .validate()) {
                                    context
                                        .read<AuthenticationCubit>()
                                        .createNewAccount(
                                          email: formInput.emailController.text,
                                          password:
                                              formInput.passwordController.text,
                                        );
                                  }
                                },
                              );
                            }
                          },
                        ),

                        SizedBox(height: context.blockHeight * 4),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                AppStrings.orSignInWith,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.blockHeight * 4),
                  Row(
                    children: [
                      Spacer(),
                      CustomSocialIcon(
                        image: Assets.imagesGoogle,
                        onTap:
                            () =>
                                BlocProvider.of<AuthenticationCubit>(
                                  context,
                                ).signInWithGoogle(),
                      ),
                      SizedBox(width: 20.w),
                      CustomSocialIcon(
                        image: Assets.imagesFacebookCircle,
                        onTap:
                            () =>
                                BlocProvider.of<AuthenticationCubit>(
                                  context,
                                ).signInWithFacebook(),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
