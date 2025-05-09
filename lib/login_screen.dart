import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'logging_widget.dart';
import 'widgets/components/custom_button_for_action.dart';
import 'widgets/components/custom_social_icon.dart';
import 'widgets/components/customized_chckbox.dart';
import 'core/routes/app_routes.dart';
import 'core/utils/app_assets.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/helper/helper_functions.dart';
import 'core/utils/size_config.dart';
import 'core/utils/theme/colors_manager.dart';
import 'core/utils/theme/text_styles.dart';
import 'firebase/firebase_auth_consumer.dart';
import 'logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'logic/provider/form_input.dart';
import 'widgets/sections/fields_section_login_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
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
                  Container(
                    height: context.blockHeight * 20,
                    width: context.blockWidth * 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesHtiLogo),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: context.blockWidth * 8,
                      end: context.blockWidth * 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.welcomeBack,
                          style: TextStyles.font25BoldWhite,
                        ),
                        Text(
                          AppStrings.enterUserNameAndPassword,
                          style: TextStyles.font14regularWhite,
                        ),
                        SizedBox(height: context.blockHeight * 3),

                        Provider.value(
                          value: formInput,
                          child: FieldsSectionLoginScreen(),
                        ),
                        SizedBox(height: context.blockHeight * 0.5),
                        Row(
                          children: [
                            CustomizedCheckbox(isChecked: false),
                            Text(
                              AppStrings.rememberMe,
                              style: TextStyles.font12regularGrey,
                            ),
                            Spacer(),
                            BlocConsumer<
                              AuthenticationCubit,
                              AuthenticationState
                            >(
                              buildWhen:
                                  (previous, current) =>
                                      current is ResetPasswordMailSentLoading ||
                                      current is ResetPasswordMailSentSuccess ||
                                      current is ResetPasswordMailSentFailed,
                              listener: (context, state) {
                                if (state is ResetPasswordMailSentSuccess) {
                                  HelperFunctions.showSnackBar(
                                    msg: state.message!,
                                    context: context,
                                  );
                                }
                                if (state is ResetPasswordMailSentFailed) {
                                  HelperFunctions.showSnackBar(
                                    msg: state.errorMessage!,
                                    context: context,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is ResetPasswordMailSentLoading) {
                                  return CircularProgressIndicator(
                                    color: ColorsManager.authScreenPurple,
                                  );
                                } else {
                                  return TextButton(
                                    onPressed: () {
                                      BlocProvider.of<AuthenticationCubit>(
                                        context,
                                      ).sendResetPasswordMail(
                                        email: formInput.emailController.text,
                                        // context: context,
                                      );
                                    },
                                    child: Text(
                                      AppStrings.forgetPassword,
                                      style: TextStyles.font12regularPurple,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: context.blockHeight * 5),

                        BlocConsumer<AuthenticationCubit, AuthenticationState>(
                          buildWhen:
                              (previous, current) =>
                                  current is AuthenticationLoading ||
                                  current is AuthenticationError ||
                                  current is AuthenticationSuccess,

                          listener: (context, state) {
                            if (state is AuthenticationSuccess) {
                              if (FirebaseAuthConsumer.isUserAuthorized()) {
                                context.pushReplacementNamed(
                                  AppRoutes.goParkScreen,
                                );
                              } else {
                                HelperFunctions.showSnackBar(
                                  msg: state.message!,
                                  context: context,
                                );
                              }
                            } else if (state is AuthenticationError) {
                              if (state.errorMessage != null) {
                                HelperFunctions.showSnackBar(
                                  msg: state.errorMessage!,
                                  context: context,
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
                                  AppStrings.signIn,
                                  style: TextStyles.font14BoldWhite,
                                ),
                                backgroundColor: ColorsManager.authScreenPurple,
                                outlineColor: ColorsManager.authScreenPurple,
                                onPressed: () {
                                  if (formInput.validateKey.currentState!
                                      .validate()) {
                                    context
                                        .read<AuthenticationCubit>()
                                        .signInWithEmailAndPassword(
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
                        SizedBox(height: context.blockHeight * 1),
                        CustomButtonForAction(
                          centerWidget: Text(
                            AppStrings.createAccount,
                            style: TextStyles.font14BoldWhite,
                          ),
                          backgroundColor: Colors.transparent,
                          outlineColor: ColorsManager.white,
                          onPressed: () {
                            context.pushNamed(AppRoutes.createAccountScreen);
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
