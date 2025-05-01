import 'package:race_tracker_project/model/race/race.dart';

abstract class RaceRepository {
  Future<void> createRace(Race race);
  Future<List<Race>> getAllRaces();
  Future<Race?> getRaceById(String raceId);
  Future<void> updateRace(Race race);
  Future<void> deleteRace(String raceId);
  Future<bool> checkRaceExists(String raceId);
}
