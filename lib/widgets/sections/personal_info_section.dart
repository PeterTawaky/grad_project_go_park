import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/app_assets.dart';
import '../../core/utils/theme/colors_manager.dart';
import '../../logic/cubits/profile_cubit/profile_cubit.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.h),
      height: 80.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Tawaky!',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Spacer(),
                    Text(
                      'Where will we go today?',
                      style: TextStyle(
                        color: ColorsManager.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      final profileCubit = BlocProvider.of<ProfileCubit>(
                        context,
                      ); //the context of bloc

                      showModalBottomSheet(
                        context: context,

                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: ColorsManager.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            height: 150.h,
                            child: Column(
                              children: [
                                Container(
                                  width: width * 0.35,
                                  height: 5.h,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: ColorsManager.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                ListTile(
                                  title: Text('Camera'),
                                  onTap: () {
                                    profileCubit.uploadNewImage(
                                      imageSource: ImageSource.camera,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Gallery'),
                                  onTap: () {
                                    profileCubit.uploadNewImage(
                                      imageSource: ImageSource.gallery,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen:
                          (previous, current) =>
                              current is SetRealImage ||
                              current is SetTempImage,
                      builder: (context, state) {
                        if (state is SetRealImage) {
                          return ClipOval(
                            child: Image.file(
                              state.image,
                              width: 70.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return ClipOval(
                            child: Image.asset(
                              Assets.imagesNnnRemovebgPreview,
                              width: 70.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
