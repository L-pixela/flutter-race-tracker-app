import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';

class CheckpointDto {
  static Map<String, dynamic> toJson(Checkpoint model) {
    return {
      'id': model.id,
      'bibNumber': model.bibNumber,
      'raceId': model.raceId,
      'startTime': model.startTime?.toIso8601String(),
      'endTime': model.endTime?.toIso8601String(),
      'segment': model.segment.label
    };
  }

  static Checkpoint fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'],
      raceId: json['raceId'],
      bibNumber: json['bibNumber'],
      segment: segmentFromString(json['segment']),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startDate']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  static RaceSegment segmentFromString(String value) {
    return RaceSegment.values.firstWhere((e) => e.label == value,
        orElse: () => throw Exception('Invalid segment value: $value'));
  }
}
