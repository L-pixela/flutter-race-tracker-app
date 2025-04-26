import 'package:race_tracker_project/model/race/location.dart';

///
/// Race Status
///
enum RaceStatus {
  ongoing("Ongoing"),
  upcoming("Upcoming"),
  completed("Completed");

  final String label;

  const RaceStatus(this.label);
}

///
/// Race Class to know which is race is being held with Location Ref
///
class Race {
  final String raceId;
  final String raceEvent;
  final Location location;
  final RaceStatus raceStatus;
  final DateTime? startDate;
  final DateTime? endDate;

  const Race({
    required this.raceId,
    required this.raceEvent,
    required this.raceStatus,
    required this.location,
    this.startDate,
    this.endDate,
  });

  bool isOngoing() => raceStatus == RaceStatus.ongoing;
  bool isCompleted() => raceStatus == RaceStatus.completed;
  bool isUpcoming() => raceStatus == RaceStatus.upcoming;

  @override
  String toString() {
    return "{Event: $raceEvent, Location: ${location.toString()}, Race Status: $raceStatus, Start Date: $startDate, End Date: $endDate}";
  }
}
