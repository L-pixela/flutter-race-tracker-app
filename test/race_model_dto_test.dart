import 'package:flutter_test/flutter_test.dart';
import 'package:race_tracker_project/data/dto/location_dto.dart';
import 'package:race_tracker_project/data/dto/race_dto.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/model/race/race.dart';

void main() {
  final testLocation = Location(name: 'Paris', region: Region.europe);
  final testRace = Race(
    raceId: 'race_001',
    raceEvent: 'Paris Marathon',
    location: testLocation,
    raceStatus: RaceStatus.ongoing,
    startDate: DateTime(2024, 10, 1, 9, 0),
  );

  group('RaceDto Tests', () {
    test('should convert Race to JSON correctly', () {
      final json = RaceDto.toJson(testRace);

      expect(json, {
        'raceId': 'race_001',
        'raceEvent': 'Paris Marathon',
        'location': LocationDto.toJson(testLocation),
        'startDate': '2024-10-01T09:00:00.000',
        'raceStatus': 'Ongoing',
      });
    });

    test('should convert JSON to Race correctly', () {
      final json = {
        'raceId': 'race_001',
        'raceEvent': 'Paris Marathon',
        'location': LocationDto.toJson(testLocation),
        'startDate': '2024-10-01T09:00:00.000',
        'raceStatus': 'Ongoing',
      };

      final result = RaceDto.fromJson(json);

      expect(result.raceId, testRace.raceId);
      expect(result.raceEvent, testRace.raceEvent);
      expect(result.location.name, testRace.location.name);
      expect(result.location.region, testRace.location.region);
      expect(result.startDate, testRace.startDate);
      expect(result.raceStatus, testRace.raceStatus);
    });

    test('should handle all status enum cases', () {
      expect(RaceDto.statusFromString('Ongoing'), RaceStatus.ongoing);
      expect(RaceDto.statusFromString('Upcoming'), RaceStatus.upcoming);
      expect(RaceDto.statusFromString('Completed'), RaceStatus.completed);
    });

    test('should throw on invalid status string', () {
      expect(() => RaceDto.statusFromString('InvalidStatus'), throwsException);
    });
  });
}
