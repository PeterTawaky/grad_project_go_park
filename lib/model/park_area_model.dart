class ParkAreaModel {
  final String id;
  final int floor;
  final String zone;
  final int spot;
  final bool available;
  final String? userId;
  final DateTime? startTime;
  final int parkNumber;

  ParkAreaModel({
    required this.id,
    required this.floor,
    required this.zone,
    required this.spot,
    required this.available,
    required this.userId,
    required this.startTime,
    required this.parkNumber,
  });
  factory ParkAreaModel.fromJson(Map<String, dynamic> json) {
    return ParkAreaModel(
      id: json['id'],
      floor: json['floor'],
      zone: json['zone'],
      spot: json['spot'],
      available: json['available'],
      userId: json['userId'],
      startTime: json['startTime'],
      parkNumber: json['parkNumber'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor': floor,
      'zone': zone,
      'spot': spot,
      'available': true,
      'userId': userId,
      'startTime': startTime,
      'parkNumber': parkNumber,
    };
  }
}
