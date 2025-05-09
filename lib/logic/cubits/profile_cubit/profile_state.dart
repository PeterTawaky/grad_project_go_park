part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ParkingInitial extends ProfileState {}

// final class ParkingLoading extends ParkingState {}

class ElevatorDataLoaded extends ProfileState {
  final ElevatorModel elevatorData;

  ElevatorDataLoaded({required this.elevatorData});
}

class RetrieveProcessSuccess extends ProfileState {
  RetrieveProcessSuccess();
}

class RetrieveProcessFailed extends ProfileState {
  final String message;

  RetrieveProcessFailed({required this.message});
}

class SetRealImage extends ProfileState {
  final File image;

  SetRealImage({required this.image});
}

class SetTempImage extends ProfileState {
  final String image;

  SetTempImage({required this.image});
}


