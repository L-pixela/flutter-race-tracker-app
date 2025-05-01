import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';

class RaceProvider extends ChangeNotifier {
  final RaceRepository repository;

  late AsyncValue<List<Race>> races;

  RaceProvider({required this.repository}) {
    races = AsyncValue.loading();
    fetchRaceData();
  }

  Future<void> addRace(Race race) async {
    try {
      // 1. check if race exist
      final isExist = await repository.checkRaceExists(race.raceId);

      if (isExist) {
        throw Exception('Race is already Registered!');
      }
      // 2. Create the race if not exist
      await repository.createRace(race);

      // 3. Fetch the data back
      await fetchRaceData();
    } catch (e) {
      races = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> fetchRaceData() async {
    // 1. Handle the loading
    races = AsyncValue.loading();
    notifyListeners();

    try {
      // 2. Fetch all of the race
      List<Race> allRaces = await repository.getAllRaces();

      // 3. Handle the success
      races = AsyncValue.success(allRaces);

      // 4. Handle the error
    } catch (e) {
      races = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> updateRace(Race newData) async {
    try {
      // 1. update the race
      await repository.updateRace(newData);
      // 2. fetch the race data
      await fetchRaceData();
      // 3. Handle the error
    } catch (e) {
      races = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> deleteRace(String raceId) async {
    try {
      await repository.deleteRace(raceId);

      await fetchRaceData();
    } catch (e) {
      races = AsyncValue.error(e);
    }
    notifyListeners();
  }
}
