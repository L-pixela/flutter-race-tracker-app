import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';

class CheckpointDto {
  static Map<String, dynamic> toJson(Checkpoint model) {
    return {
      'bibNumber': model.bibNumber,
      'raceId': model.raceId,
      'timeStamp': model.timeStamp.toIso8601String(),
      'segment': model.segment.label
    };
  }

  static Checkpoint fromJson(Map<String, dynamic> json) {
    return Checkpoint(
        raceId: json['raceId'],
        bibNumber: json['bibNumber'],
        segment: segmentFromString(json['segment']),
        timeStamp: DateTime.parse(json['timeStamp']));
  }

  static RaceSegment segmentFromString(String value) {
    return RaceSegment.values.firstWhere((e) => e.label == value,
        orElse: () => throw Exception('Invalid segment value: $value'));
  }
}
