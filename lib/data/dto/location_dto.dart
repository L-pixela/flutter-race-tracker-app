import 'package:race_tracker_project/model/race/location.dart';

class LocationDto {
  static Map<String, dynamic> toJson(Location model) {
    return {'name': model.name, 'region': model.region.label};
  }

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
        name: json['name'], region: regionFromString(json['region']));
  }

  static Region regionFromString(String value) {
    return Region.values.firstWhere(
      (e) => e.label == value,
      orElse: () => throw Exception('Invalid region value: $value'),
    );
  }
}
