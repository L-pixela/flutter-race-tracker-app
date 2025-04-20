import 'package:flutter_test/flutter_test.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/data/dto/location_dto.dart';

void main() {
  final testLocation = Location(name: 'Tokyo', region: Region.asia);

  group('LocationDto Tests', () {
    test('should convert Location to JSON correctly', () {
      final json = LocationDto.toJson(testLocation);

      expect(json, {
        'name': 'Tokyo',
        'region': 'Asia',
      });
    });

    test('should convert JSON to Location correctly', () {
      final json = {
        'name': 'Tokyo',
        'region': 'Asia',
      };

      final result = LocationDto.fromJson(json);

      expect(result.name, testLocation.name);
      expect(result.region, testLocation.region);
    });

    test('should throw on invalid region string', () {
      final invalidJson = {
        'name': 'UnknownLand',
        'region': 'moon',
      };

      expect(() => LocationDto.fromJson(invalidJson), throwsException);
    });
  });
}
