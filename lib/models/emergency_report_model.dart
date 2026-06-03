class EmergencyReportModel {
  final int? id;
  final int userId;
  final String emergencyType;
  final String trainNumber;
  final String coachNumber;
  final String seatNumber;
  final double latitude;
  final double longitude;
  final String status;
  final String createdAt;

  EmergencyReportModel({
    this.id,
    required this.userId,
    required this.emergencyType,
    required this.trainNumber,
    required this.coachNumber,
    required this.seatNumber,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory EmergencyReportModel.fromMap(Map<String, dynamic> json) {
    return EmergencyReportModel(
      id: json['id'],
      userId: json['user_id'],
      emergencyType: json['emergency_type'],
      trainNumber: json['train_number'],
      coachNumber: json['coach_number'],
      seatNumber: json['seat_number'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': createdAt,
    };
  }
}