import 'package:race_tracker_project/data/repository/location_repository.dart';
import 'package:race_tracker_project/model/race/location.dart';

class MockLocationRepository implements LocationRepository {
  final List<Location> _locations = [
    Location(name: 'Paris', region: Region.europe),
    Location(name: 'Tokyo', region: Region.asia),
    Location(name: 'Rio', region: Region.southAmerica),
    Location(name: 'Sydney', region: Region.oceania),
  ];

  @override
  Future<void> addLocation(Location location) async {
    _locations.add(location);
  }

  @override
  Future<List<Location>> getAllLocations() async => _locations;
}
