import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../core/routes/app_routes.dart';
import '../core/utils/helper/helper_functions.dart';
import '../logic/cubits/parking_timer_cubit/parking_timer_cubit.dart';
import '../widgets/components/fees_container_widget.dart';
import '../widgets/sections/elevator_container_widget.dart';
import '../widgets/sections/parking_section_container_widget.dart';
import '../widgets/sections/personal_info_section.dart';
import '../logic/cubits/profile_cubit/profile_cubit.dart';
import '../model/park_area_model.dart';
import '../widgets/components/modern_button.dart';
import '../widgets/components/timer_display_component.dart';

class ProfileScreen extends StatefulWidget {
  final ParkAreaModel parkArea;
  const ProfileScreen({super.key, required this.parkArea});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RetrieveProcessSuccess) {
          context.read<ParkingTimerCubit>().stopParking();
          context.pushReplacement(AppRoutes.goParkScreen);
        } else if (state is RetrieveProcessFailed) {
          HelperFunctions.showSnackBar(msg: state.message, context: context);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: height * 0.05),
            PersonalInfoSection(width: width),
            Spacer(flex: 1),
        
            TimerDisplayComponent(),
            Spacer(flex: 2),
        
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
        
            Spacer(flex: 3),
        
            Builder(
              builder: (context) {
                return ModernButton(
                  text: "Retrieve Car",
                  onPressed: () {
                    BlocProvider.of<ProfileCubit>(
                      context,
                    ).retrieveCar(parkAreaId: widget.parkArea.id);
                    
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
