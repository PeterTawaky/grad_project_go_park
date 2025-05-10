part of 'internet_bloc.dart';

@immutable
sealed class InternetState {}

final class InternetInitial extends InternetState {}

final class ConnectedState extends InternetState {}

final class NotConnectedState extends InternetState {}
