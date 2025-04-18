import 'package:race_tracker_project/model/race/location.dart';

///
/// Race Status
///
enum RaceStatus { ongoing, upcoming, completed }

///
/// Race Class to know which is race is being held with Location Ref
///
class Race {
  final String raceId;
  final String raceEvent;
  final Location location;
  final RaceStatus raceStatus;
  final DateTime date;

  const Race(
      this.raceId, this.raceEvent, this.raceStatus, this.location, this.date);

  @override
  String toString() {
    return "{Event: $raceEvent, Location: ${location.toString()}, Race Status: $raceStatus, Date: $date}";
  }
}
