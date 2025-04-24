import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/model/race/race.dart';

class MockRaceRepository implements RaceRepository {
  final Map<String, Race> _races = {
    'r1': Race(
      raceId: 'r1',
      raceEvent: 'City Triathlon',
      raceStatus: RaceStatus.ongoing,
      location: Location(name: 'Paris', region: Region.europe),
      date: DateTime.now(),
    ),
    'r2': Race(
      raceId: 'r2',
      raceEvent: 'Beach Dash',
      raceStatus: RaceStatus.upcoming,
      location: Location(name: 'Sydney', region: Region.oceania),
      date: DateTime.now().add(Duration(days: 5)),
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
}
