class LocalWorkingHourTimings {
  int id;
  int workingHourId;
  String openTime;
  String closeTime;
  String isOpened;

  LocalWorkingHourTimings({
    required this.id,
    required this.workingHourId,
    required this.openTime,
    required this.closeTime,
    required this.isOpened,
  });

  factory LocalWorkingHourTimings.fromJson(Map<String, dynamic> json) {
    return LocalWorkingHourTimings(
      id: json['id'],
      workingHourId: json['working_hour_id'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      isOpened: json['is_opened'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'working_hour_id': workingHourId,
      'open_time': openTime,
      'close_time': closeTime,
      'is_opened': isOpened,
    };
  }
}
