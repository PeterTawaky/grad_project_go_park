part of 'parking_cubit.dart';

@immutable
sealed class ParkingState {}

final class ParkingInitial extends ParkingState {}


class ParkingProcessSuccess extends ParkingState {
  final ParkAreaModel parkArea;

  ParkingProcessSuccess({required this.parkArea});
}

class ParkingProcessFaild extends ParkingState {
  final String message;

  ParkingProcessFaild({required this.message});
}
