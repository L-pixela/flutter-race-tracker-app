import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/model/race/race.dart';

class MockRaceRepository implements RaceRepository {
  final Map<String, Race> _races = {
    'R1': Race(
      raceId: 'r1',
      raceEvent: 'City Triathlon',
      raceStatus: RaceStatus.ongoing,
      location: Location(name: 'Paris', region: Region.europe),
      startDate: DateTime.now(),
    ),
  };

  @override
  Future<void> createRace(Race race) async {
    _races[race.raceId] = race;
  }

  @override
  Future<List<Race>> getAllRaces() async => _races.values.toList();

  @override
  Future<Race?> getRaceById(String raceId) async => _races[raceId];

  @override
  Future<void> updateRace(Race race) async {
    _races[race.raceId] = race;
  }

  @override
  Future<void> deleteRace(String raceId) async {
    _races.remove(raceId);
  }

  @override
  Future<bool> checkRaceExists(String raceId) {
    // TODO: implement checkRaceExists
    throw UnimplementedError();
  }
}
