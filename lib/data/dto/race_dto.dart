import 'package:race_tracker_project/data/dto/location_dto.dart';
import 'package:race_tracker_project/model/race/race.dart';

class RaceDto {
  static Map<String, dynamic> toJson(Race model) {
    return {
      'raceId': model.raceId,
      'raceEvent': model.raceEvent,
      'location': LocationDto.toJson(model.location),
      'startDate': model.startDate!.toIso8601String(),
      'endDate': model.endDate!.toIso8601String(),
      'raceStatus': model.raceStatus.label
    };
  }

  static Race fromJson(Map<String, dynamic> json) {
    return Race(
        raceId: json['raceId'],
        raceEvent: json['raceEvent'],
        raceStatus: statusFromString(json['raceStatus']),
        location: LocationDto.fromJson(json['location']),
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']));
  }

  static RaceStatus statusFromString(String value) {
    return RaceStatus.values.firstWhere(
      (e) => e.label == value,
      orElse: () => throw Exception('Invalid status value: $value'),
    );
  }
}
