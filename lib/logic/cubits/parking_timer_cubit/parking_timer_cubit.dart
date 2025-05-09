import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';
import 'package:smart_garage_final_project/logic/cubits/parking_timer_cubit/parking_timer_state.dart';

class ParkingTimerCubit extends Cubit<ParkingTimerState> {
  Timer? _timer;

  ParkingTimerCubit() : super(const ParkingTimerState.initial()) {
    // Auto-start parking when cubit is created
    _autoStartParking();
  }

  void _autoStartParking() {
    final storedStartTime = CachedData.getData(
      key: KeysManager.parkingStartTime,
    );

    if (storedStartTime != null) {
      // Resume existing parking session
      final startTime = DateTime.parse(storedStartTime);
      _startTimer(startTime);
    } else {
      // Start new parking session automatically
      startParking();
    }
  }

  void startParking() {
    final startTime = DateTime.now();
    CachedData.setData(
      key: KeysManager.parkingStartTime,
      value: startTime.toIso8601String(),
    );
    _startTimer(startTime);
  }

  void _startTimer(DateTime startTime) {
    // Calculate initial duration
    Duration initialDuration = DateTime.now().difference(startTime);
    emit(ParkingTimerState.running(startTime, initialDuration));

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentDuration = DateTime.now().difference(startTime);
      emit(ParkingTimerState.running(startTime, currentDuration));
    });
  }

  void stopParking() {
    _timer?.cancel();
    _timer = null;
    CachedData.deleteItem(key: KeysManager.parkingStartTime);
    emit(const ParkingTimerState.initial());

    // Optionally restart parking automatically after stopping
    // Future.delayed(Duration.zero, () => startParking());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
