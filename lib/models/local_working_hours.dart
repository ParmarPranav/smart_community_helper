import 'local_working_hour_timings.dart';

class LocalWorkingHours {
  int id;
  String day;
  List<LocalWorkingHourTimings> localWorkingHourTimingsList;

  LocalWorkingHours({
    required this.id,
    required this.day,
    required this.localWorkingHourTimingsList,
  });

  factory LocalWorkingHours.fromJson(Map<String, dynamic> json) {
    return LocalWorkingHours(
      id: json['id'],
      day: json['day'],
      localWorkingHourTimingsList: (json['local_working_timing_list'] as List<dynamic>).map((e) {
        return LocalWorkingHourTimings.fromJson(e);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'local_working_timing_list': localWorkingHourTimingsList.map((e) {
        return e.toJson();
      }).toList()
    };
  }
}
