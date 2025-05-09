class ParkingTimerState {
  final DateTime? startTime;
  final Duration duration;
  final bool isActive;

  const ParkingTimerState.initial()
      : startTime = null,
        duration = Duration.zero,
        isActive = false;

  const ParkingTimerState.running(DateTime this.startTime, Duration this.duration)
      : isActive = true;

  String get formattedDuration {
    return '${duration.inHours.toString().padLeft(2, '0')}:'
           '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
           '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double get price {
    // 100 per hour = 0.027777... per second
    return duration.inSeconds * 0.0277777777777778;
  }
}