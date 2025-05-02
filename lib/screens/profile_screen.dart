import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/size_config.dart';
import 'package:smart_garage_final_project/core/utils/theme/fonts_manager.dart';
import 'package:smart_garage_final_project/core/utils/theme/text_styles.dart';
import 'package:smart_garage_final_project/firebase/flutter_fire_store_consumer.dart';
import 'package:smart_garage_final_project/logic/cubits/parking_cubit/parking_cubit.dart';
import 'package:smart_garage_final_project/model/park_area_model.dart';
import 'package:smart_garage_final_project/widgets/components/timer_display_component.dart';
import 'package:smart_garage_final_project/core/utils/app_assets.dart';
import 'package:smart_garage_final_project/core/utils/theme/colors_manager.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imgFile;
  double _price = 0;

  late int timeInSecond;
  late int timeInMinutes;
  late int timeInHours;

  List<ParkAreaModel> parkAreaList = [
    ParkAreaModel(
      id: "P1-A1",
      floor: 1,
      zone: "A",
      spot: 1,
      occupied: false,
      userId: "",
      startTime: "",
      parkNumber: 1,
    ),
    ParkAreaModel(
      id: "P1-A2",
      floor: 1,
      zone: "A",
      spot: 2,
      occupied: false,
      userId: "",
      startTime: "",
      parkNumber: 2,
    ),
    ParkAreaModel(
      id: "P1-A3",
      floor: 1,
      zone: "A",
      spot: 3,
      occupied: false,
      userId: "",
      startTime: "",
      parkNumber: 3,
    ),
    // ParkAreaModel(
    //   id: "P1-A4",
    //   floor: 1,
    //   zone: "A",
    //   spot: 4,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 4,
    // ),
    // ParkAreaModel(
    //   id: "P1-A5",
    //   floor: 1,
    //   zone: "A",
    //   spot: 5,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 5,
    // ),
    // ParkAreaModel(
    //   id: "P1-B1",
    //   floor: 1,
    //   zone: "B",
    //   spot: 1,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 6,
    // ),
    // ParkAreaModel(
    //   id: "P1-B2",
    //   floor: 1,
    //   zone: "B",
    //   spot: 2,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 7,
    // ),
    // ParkAreaModel(
    //   id: "P1-B3",
    //   floor: 1,
    //   zone: "B",
    //   spot: 3,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 8,
    // ),
    // ParkAreaModel(
    //   id: "P1-B4",
    //   floor: 1,
    //   zone: "B",
    //   spot: 4,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 9,
    // ),
    // ParkAreaModel(
    //   id: "P1-B5",
    //   floor: 1,
    //   zone: "B",
    //   spot: 5,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 10,
    // ),
    // ParkAreaModel(
    //   id: "P2-C1",
    //   floor: 2,
    //   zone: "C",
    //   spot: 1,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 11,
    // ),
    // ParkAreaModel(
    //   id: "P2-C2",
    //   floor: 2,
    //   zone: "C",
    //   spot: 2,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 12,
    // ),
    // ParkAreaModel(
    //   id: "P2-C3",
    //   floor: 2,
    //   zone: "C",
    //   spot: 3,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 13,
    // ),
    // ParkAreaModel(
    //   id: "P2-C4",
    //   floor: 2,
    //   zone: "C",
    //   spot: 4,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 14,
    // ),
    // ParkAreaModel(
    //   id: "P2-C5",
    //   floor: 2,
    //   zone: "C",
    //   spot: 5,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 15,
    // ),
    // ParkAreaModel(
    //   id: "P2-D1",
    //   floor: 2,
    //   zone: "D",
    //   spot: 1,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 16,
    // ),
    // ParkAreaModel(
    //   id: "P2-D2",
    //   floor: 2,
    //   zone: "D",
    //   spot: 2,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 17,
    // ),
    // ParkAreaModel(
    //   id: "P2-D3",
    //   floor: 2,
    //   zone: "D",
    //   spot: 3,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 18,
    // ),
    // ParkAreaModel(
    //   id: "P2-D4",
    //   floor: 2,
    //   zone: "D",
    //   spot: 4,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 19,
    // ),
    // ParkAreaModel(
    //   id: "P2-D5",
    //   floor: 2,
    //   zone: "D",
    //   spot: 5,
    //   occupied: false,
    //   userId: "",
    //   startTime: "",
    //   parkNumber: 20,
    // ),
  ];

  _getImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        imgFile = File(pickedImage.path);
      });
      CachedData.setData(
        key: KeysManager.profilePhoto,
        value: pickedImage.path,
      );
    }
  }

  _getImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        imgFile = File(pickedImage.path);
      });
      CachedData.setData(
        key: KeysManager.profilePhoto,
        value: pickedImage.path,
      );
    }
  }

  _startCount() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeInSecond == 59) {
          timeInSecond = 0;
          timeInMinutes++;
          CachedData.setData(
            key: KeysManager.timeInMinutes,
            value: timeInMinutes,
          );
        }
        if (timeInMinutes == 59) {
          timeInMinutes = 0;
          timeInHours++;
          CachedData.setData(key: KeysManager.timeInHours, value: timeInHours);
        }
        _price =
            (timeInSecond * 0.0277777777777778) +
            (timeInMinutes * 1.66666666666667) +
            (timeInHours * 100);
        CachedData.setData(
          key: KeysManager.timeInSeconds,
          value: timeInSecond++,
        );
      });
    });
  }

  @override
  void initState() {
    if (CachedData.getData(key: KeysManager.profilePhoto) != null) {
      imgFile = File(CachedData.getData(key: KeysManager.profilePhoto));
    }
    timeInSecond = CachedData.getData(key: KeysManager.timeInSeconds) ?? 0;
    timeInMinutes = CachedData.getData(key: KeysManager.timeInMinutes) ?? 0;
    timeInHours = CachedData.getData(key: KeysManager.timeInHours) ?? 0;
    _startCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFireStoreConsumer.setListofData(
            collectionName: 'Parking Areas',
            dataList: parkAreaList.map((e) => e.toJson()).toList(),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),

                                      ListTile(
                                        title: Text('Camera'),
                                        onTap: () {
                                          _getImageFromCamera();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Gallery'),
                                        onTap: () {
                                          _getImageFromGallery();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipOval(
                            child: ConditionalBuilder(
                              condition: imgFile != null,
                              builder:
                                  (context) => Image.file(
                                    imgFile!,
                                    width: 70.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                              fallback:
                                  (context) => Image.asset(
                                    Assets
                                        .imagesNnnRemovebgPreview, // Change to your image path
                                    width: 70.w, // Adjust size
                                    height: 80.h,
                                    fit:
                                        BoxFit
                                            .cover, // Ensures the image fills the oval
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          TimerDisplayComponent(
            timeInHours: timeInHours,
            timeInMinutes: timeInMinutes,
            timeInSecond: timeInSecond,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: height * 0.35,
            child: Row(
              spacing: 5.w,
              children: [
                ParkingSectionContainerWidget(),
                Expanded(
                  child: Column(
                    spacing: 5.h,
                    children: [
                      FeesContainerWidget(price: _price),
                      ElevatorContainerWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Spacer(),
          Container(
            width: width * 0.35,
            height: 5,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorsManager.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingSectionContainerWidget extends StatelessWidget {
  const ParkingSectionContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 20.w),
              padding: EdgeInsetsDirectional.only(top: 15.h, start: 20.w),

              decoration: BoxDecoration(
                color: ColorsManager.yellow,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'section',
                    style: TextStyle(
                      color: ColorsManager.grey,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    'P1-A1',
                    style: TextStyles.font25BoldWhite.copyWith(
                      letterSpacing: 3,
                      color: ColorsManager.black,
                      fontSize: 34.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 60.h,
            right: -20.w,
            child: Image.asset(
              Assets.imagesBmwCarWithoutBackground,
              width: context.blockWidth * 50,
              height: context.blockHeight * 30,
            ),
          ),
        ],
      ),
    );
  }
}

class ElevatorContainerWidget extends StatelessWidget {
  const ElevatorContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsetsDirectional.only(end: 20.w),
        padding: EdgeInsetsDirectional.only(start: 5.w),
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: BlocBuilder<ParkingCubit, ParkingState>(
          builder: (context, state) {
            if (state is ElevatorDataLoaded) {
              final data = state.elevatorData;
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 5.h,
                      bottom: 15.h,
                      start: 10.w,
                    ),
                    child: Column(
                      spacing: 4.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Elevator',
                          style: TextStyle(
                            color: ColorsManager.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          data.available ? 'available\nnow' : 'not\navailable',
                          style: TextStyle(
                            color: data.available ? Colors.teal : Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
                    child: Container(
                      height: double.infinity,
                      width: context.blockWidth * 14,
                      // width: context.blockWidth * 15.7142,
                      decoration: BoxDecoration(
                        color: ColorsManager.lightBlack,
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: Icon(
                        //TODO change color accoding to availability
                        Icons.elevator_outlined,
                        size: 42.sp,
                        color: data.available ? Colors.teal : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: ColorsManager.authScreenPurple,
              ),
            ); //TODO when get Data
          },
        ),
      ),
    );
  }
}

class FeesContainerWidget extends StatelessWidget {
  const FeesContainerWidget({super.key, required double price})
    : _price = price;
  final double _price;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsetsDirectional.only(end: 20.w),

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: ColorsManager.lightBlack,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 5, top: 5),
              child: Container(
                height: double.infinity,
                width: context.blockWidth * 15.7142,
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Icon(Icons.attach_money, size: 35),
              ),
            ),

            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 5.h,
                bottom: 15.h,
                start: 10.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'fees',
                    style: TextStyle(
                      color: ColorsManager.grey,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    '${_price.floor()}',
                    style: TextStyle(
                      color: ColorsManager.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
