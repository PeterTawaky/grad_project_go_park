import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_garage_final_project/core/routes/app_routes.dart';
import 'package:smart_garage_final_project/core/utils/helper/helper_functions.dart';
import 'package:smart_garage_final_project/logic/cubits/parking_timer_cubit/parking_timer_cubit.dart';
import 'package:smart_garage_final_project/logic/cubits/parking_timer_cubit/parking_timer_state.dart';
import '../cached/cache_helper.dart';
import '../core/utils/size_config.dart';
import '../core/utils/theme/text_styles.dart';
import '../firebase/flutter_fire_store_consumer.dart';
import '../logic/cubits/profile_cubit/profile_cubit.dart';
import '../model/park_area_model.dart';
import '../widgets/components/modern_button.dart';
import '../widgets/components/timer_display_component.dart';
import '../core/utils/app_assets.dart';
import '../core/utils/theme/colors_manager.dart';
import '../core/utils/keys_manager.dart';

class ProfileScreen extends StatefulWidget {
  final ParkAreaModel parkArea;
  const ProfileScreen({super.key, required this.parkArea});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File? imgFile;
  // double _price = 0;

  // late int timeInSecond;
  // late int timeInMinutes;
  // late int timeInHours;

  List<ParkAreaModel> parkAreaList = [
    ParkAreaModel(
      id: "P1-A1",
      floor: 1,
      zone: "A",
      spot: 1,
      available: true,
      userId: "",
      startTime: null,
      parkNumber: 1,
    ),
    ParkAreaModel(
      id: "P1-A2",
      floor: 1,
      zone: "A",
      spot: 2,
      available: true,
      userId: "",
      startTime: null,
      parkNumber: 2,
    ),
    ParkAreaModel(
      id: "P1-A3",
      floor: 1,
      zone: "A",
      spot: 3,
      available: true,
      userId: "",
      startTime: null,
      parkNumber: 3,
    ),
    ParkAreaModel(
      id: "P1-A4",
      floor: 1,
      zone: "A",
      spot: 4,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 4,
    ),
    ParkAreaModel(
      id: "P1-A5",
      floor: 1,
      zone: "A",
      spot: 5,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 5,
    ),
    ParkAreaModel(
      id: "P1-B1",
      floor: 1,
      zone: "B",
      spot: 1,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 6,
    ),
    ParkAreaModel(
      id: "P1-B2",
      floor: 1,
      zone: "B",
      spot: 2,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 7,
    ),
    ParkAreaModel(
      id: "P1-B3",
      floor: 1,
      zone: "B",
      spot: 3,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 8,
    ),
    ParkAreaModel(
      id: "P1-B4",
      floor: 1,
      zone: "B",
      spot: 4,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 9,
    ),
    ParkAreaModel(
      id: "P1-B5",
      floor: 1,
      zone: "B",
      spot: 5,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 10,
    ),
    ParkAreaModel(
      id: "P2-C1",
      floor: 2,
      zone: "C",
      spot: 1,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 11,
    ),
    ParkAreaModel(
      id: "P2-C2",
      floor: 2,
      zone: "C",
      spot: 2,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 12,
    ),
    ParkAreaModel(
      id: "P2-C3",
      floor: 2,
      zone: "C",
      spot: 3,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 13,
    ),
    ParkAreaModel(
      id: "P2-C4",
      floor: 2,
      zone: "C",
      spot: 4,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 14,
    ),
    ParkAreaModel(
      id: "P2-C5",
      floor: 2,
      zone: "C",
      spot: 5,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 15,
    ),
    ParkAreaModel(
      id: "P2-D1",
      floor: 2,
      zone: "D",
      spot: 1,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 16,
    ),
    ParkAreaModel(
      id: "P2-D2",
      floor: 2,
      zone: "D",
      spot: 2,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 17,
    ),
    ParkAreaModel(
      id: "P2-D3",
      floor: 2,
      zone: "D",
      spot: 3,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 18,
    ),
    ParkAreaModel(
      id: "P2-D4",
      floor: 2,
      zone: "D",
      spot: 4,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 19,
    ),
    ParkAreaModel(
      id: "P2-D5",
      floor: 2,
      zone: "D",
      spot: 5,
      available: true,
      startTime: null,
      userId: "",
      parkNumber: 20,
    ),
  ];
  //!==========================================================
  // // Timer control
  // Timer? _timer;

  // // Time tracking variables
  // Duration _parkingDuration = Duration.zero;

  // // Parking state
  // bool _isParkingActive = false;
  // DateTime? _parkingStartTime;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadParkingSession();
  //    _isParkingActive ? null : startParking();
  // }

  // void _loadParkingSession() {
  //   // Load from shared preferences or your cache
  //   final storedStartTime = CachedData.getData(
  //     key: KeysManager.parkingStartTime,
  //   );
  //   if (storedStartTime != null) {
  //     _parkingStartTime = DateTime.parse(storedStartTime);
  //     _isParkingActive = true;
  //     _startTimer();
  //   }
  // }

  // void _startTimer() {
  //   // Calculate initial duration
  //   if (_parkingStartTime != null) {
  //     _parkingDuration = DateTime.now().difference(_parkingStartTime!);
  //   }

  //   // Update UI every second
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_parkingStartTime != null) {
  //       setState(() {
  //         _parkingDuration = DateTime.now().difference(_parkingStartTime!);
  //       });
  //     }
  //   });
  // }

  // void startParking() {
  //   setState(() {
  //     _parkingStartTime = DateTime.now();
  //     _isParkingActive = true;
  //     _parkingDuration = Duration.zero;
  //   });

  //   // Save to storage
  //   CachedData.setData(
  //     key: KeysManager.parkingStartTime,
  //     value: _parkingStartTime!.toIso8601String(),
  //   );

  //   _startTimer();
  // }

  // void stopParking() {
  //   _timer?.cancel();
  //   _timer = null;

  //   setState(() {
  //     _isParkingActive = false;
  //     _parkingStartTime = null;
  //   });

  //   // Clear storage
  //   CachedData.deleteItem(key: KeysManager.parkingStartTime);
  // }

  // String _formatDuration(Duration duration) {
  //   return '${duration.inHours.toString().padLeft(2, '0')}:'
  //       '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
  //       '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  // }

  // double _calculatePrice(Duration duration) {
  //   // 100 per hour = 0.027777... per second
  //   return duration.inSeconds * 0.0277777777777778;
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }
  //!==========================================================

  // _startCount() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (timeInSecond == 59) {
  //         timeInSecond = 0;
  //         timeInMinutes++;
  //         CachedData.setData(
  //           key: KeysManager.timeInMinutes,
  //           value: timeInMinutes,
  //         );
  //       }
  //       if (timeInMinutes == 59) {
  //         timeInMinutes = 0;
  //         timeInHours++;
  //         CachedData.setData(key: KeysManager.timeInHours, value: timeInHours);
  //       }
  //       _price =
  //           (timeInSecond * 0.0277777777777778) +
  //           (timeInMinutes * 1.66666666666667) +
  //           (timeInHours * 100);
  //       CachedData.setData(
  //         key: KeysManager.timeInSeconds,
  //         value: timeInSecond++,
  //       );
  //     });
  //   });
  // }

  @override
  // void initState() {
  //   timeInSecond = CachedData.getData(key: KeysManager.timeInSeconds) ?? 0;
  //   timeInMinutes = CachedData.getData(key: KeysManager.timeInMinutes) ?? 0;
  //   timeInHours = CachedData.getData(key: KeysManager.timeInHours) ?? 0;
  //   // _startCount();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RetrieveProcessSuccess) {
          context.pushReplacement(AppRoutes.goParkScreen);
        } else if (state is RetrieveProcessFailed) {
          HelperFunctions.showSnackBar(msg: state.message, context: context);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFireStoreConsumer.setListofData(
              collectionName: 'Parking Areas',
              dataList: parkAreaList.map((e) => e.toJson()).toList(),
            );
          },
          child: Icon(Icons.add),
        ),
        body: BlocProvider(
          create: (context) => ParkingTimerCubit(),
          child: Column(
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
                                final profileCubit =
                                    BlocProvider.of<ProfileCubit>(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                imageSource:
                                                    ImageSource.gallery,
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
                                  } else if (state is SetTempImage) {
                                    return ClipOval(
                                      child: Image.asset(
                                        state.image,
                                        width: 70.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Parking Duration: ${_formatDuration(_parkingDuration)}',
              //       style: const TextStyle(
              //         fontSize: 24,
              //         color: ColorsManager.white,
              //       ),
              //     ),
              //     const SizedBox(height: 20),
              //     Text(
              //       'Current Price: \$${_calculatePrice(_parkingDuration).toStringAsFixed(2)}',
              //       style: const TextStyle(
              //         fontSize: 24,
              //         color: ColorsManager.white,
              //       ),
              //     ),
              //     const SizedBox(height: 40),
              //     ElevatedButton(
              //       onPressed: _isParkingActive ? null : startParking,
              //       child: const Text('Start Parking'),
              //     ),
              //     const SizedBox(height: 20),
              //     ElevatedButton(
              //       onPressed: _isParkingActive ? stopParking : null,
              //       child: const Text('Stop Parking'),
              //     ),
              //   ],
              // ),
              TimerDisplayComponent(),
              SizedBox(height: 20.h),
              SizedBox(
                height: height * 0.35,
                child: Row(
                  spacing: 5.w,
                  children: [
                    ParkingSectionContainerWidget(areaId: widget.parkArea.id),
                    Expanded(
                      child: Column(
                        spacing: 5.h,
                        children: [
                          FeesContainerWidget(),
                          ElevatorContainerWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              Builder(
                builder: (context) {
                  return ModernButton(
                    text: "Retrieve Car",
                    onPressed: () {
                      BlocProvider.of<ProfileCubit>(
                        context,
                      ).retrieveCar(parkAreaId: widget.parkArea.id);
                      context.read<ParkingTimerCubit>().stopParking();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParkingSectionContainerWidget extends StatelessWidget {
  final String areaId;
  const ParkingSectionContainerWidget({super.key, required this.areaId});

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
                    areaId,
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
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) => current is ElevatorDataLoaded,
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
  const FeesContainerWidget({
    super.key,
    // required double price
  });
  // : _price = price;
  // final double _price;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingTimerCubit, ParkingTimerState>(
      builder: (context, state) {
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
                        '${state.price.toInt()}',
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
      },
    );
  }
}

//!======================================================================
