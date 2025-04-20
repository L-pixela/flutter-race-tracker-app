import 'package:race_tracker_project/model/race/location.dart';

abstract class LocationRepository {
  Future<void> addLocation(Location location);
  Future<List<Location>> getAllLocations();
}
