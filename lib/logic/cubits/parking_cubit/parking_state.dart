part of 'parking_cubit.dart';

@immutable
sealed class ParkingState {}

final class ParkingInitial extends ParkingState {}

// final class ParkingLoading extends ParkingState {}

class ElevatorDataLoaded extends ParkingState {
  final ElevatorModel elevatorData;

  ElevatorDataLoaded({required this.elevatorData});
}


