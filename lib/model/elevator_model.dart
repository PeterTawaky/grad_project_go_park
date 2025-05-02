class ElevatorModel {
  final String? userId;
  final bool available;
  final String? parkSection;

  ElevatorModel({
    required this.userId,
    required this.available,
    required this.parkSection,
  });

  factory ElevatorModel.fromJson(Map<String, dynamic> json) {
    return ElevatorModel(
      userId: json['userId'],
      available: json['available'],
      parkSection: json['parkSection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'available': available,
      'parkSection': parkSection,
    };
  }
}
