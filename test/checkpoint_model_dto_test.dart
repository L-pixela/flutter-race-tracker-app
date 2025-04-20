import 'package:flutter_test/flutter_test.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/data/dto/checkpoint_dto.dart';

void main() {
  final testDateTime = DateTime(2025, 4, 20, 12, 0);
  final testCheckpoint = Checkpoint(
    raceId: 'race_001',
    bibNumber: 99,
    segment: RaceSegment.running,
    timeStamp: testDateTime,
  );

  group('CheckpointDto Tests', () {
    test('should convert Checkpoint to JSON correctly', () {
      final json = CheckpointDto.toJson(testCheckpoint);

      expect(json, {
        'raceId': 'race_001',
        'bibNumber': 99,
        'segment': 'Running',
        'timeStamp': testDateTime.toIso8601String(),
      });
    });

    test('should convert JSON to Checkpoint correctly', () {
      final json = {
        'raceId': 'race_001',
        'bibNumber': 99,
        'segment': 'Running',
        'timeStamp': '2025-04-20T12:00:00.000',
      };

      final checkpoint = CheckpointDto.fromJson(json);

      expect(checkpoint.raceId, testCheckpoint.raceId);
      expect(checkpoint.bibNumber, testCheckpoint.bibNumber);
      expect(checkpoint.segment, testCheckpoint.segment);
      expect(checkpoint.timeStamp, testCheckpoint.timeStamp);
    });

    test('should throw exception on invalid segment', () {
      final json = {
        'raceId': 'race_001',
        'bibNumber': 99,
        'segment': 'InvalidSegment',
        'timeStamp': '2025-04-20T12:00:00.000',
      };

      expect(() => CheckpointDto.fromJson(json), throwsException);
    });
  });
}
