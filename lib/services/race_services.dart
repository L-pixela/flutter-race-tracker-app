import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';

class RaceServices {
  final RaceProvider raceProvider;

  RaceServices({required this.raceProvider});

  Future<void> startRace(Race race) async {
    if (race.isOngoing() || race.isCompleted()) return;

    final updatedRace = Race(
      raceId: race.raceId,
      raceEvent: race.raceEvent,
      location: race.location,
      raceStatus: RaceStatus.ongoing,
      startDate: DateTime.now(),
      endDate: null,
    );

    await raceProvider.updateRace(updatedRace);
  }

  Future<void> stopRace(Race race) async {
    if (!race.isOngoing()) return;

    final updatedRace = Race(
      raceId: race.raceId,
      raceEvent: race.raceEvent,
      location: race.location,
      raceStatus: RaceStatus.completed,
      startDate: race.startDate,
      endDate: DateTime.now(),
    );

    await raceProvider.updateRace(updatedRace);
  }

  Duration getElapsedTime(Race race) {
    if (race.startDate == null) return Duration.zero;
    final endTime = race.endDate ?? DateTime.now();
    return endTime.difference(race.startDate!);
  }
}
