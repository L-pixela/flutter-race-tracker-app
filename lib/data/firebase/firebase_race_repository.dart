import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/race_dto.dart';
import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/model/race/race.dart';

class FirebaseRaceRepository implements RaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'races';

  /// Create race in Firestore
  @override
  Future<void> createRace(Race race) async {
    try {
      final raceJson = RaceDto.toJson(race);
      await _firestore.collection(_collection).doc(race.raceId).set(raceJson);
      // print(" Race created successfully");
    } catch (e) {
      throw Exception('Failed to create race: $e');
    }
  }

  /// Delete race from Firestore
  @override
  Future<void> deleteRace(String raceId) async {
    try {
      await _firestore.collection(_collection).doc(raceId).delete();
      // print("Race deleted successfully");
    } catch (e) {
      throw Exception('Failed to delete race: $e');
    }
  }

  /// Fetch all of the races from Firestore
  @override
  Future<List<Race>> getAllRaces() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      // print("Race Fetched successfully");
      return snapshot.docs.map((doc) => RaceDto.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch races: $e');
    }
  }

  @override
  Future<Race?> getRaceById(String raceId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(raceId).get();
      if (doc.exists) {
        // print("Race Fetched successfully");
        // Convert the document data
        return RaceDto.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch race: $e');
    }
  }

  @override
  Future<void> updateRace(Race race) async {
    try {
      final raceJson = RaceDto.toJson(race);
      await _firestore.collection(_collection).doc(race.raceId).set(raceJson);
      // print("Race updated successfully");
    } catch (e) {
      throw Exception('Failed to update race: $e');
    }
  }

  @override
  Future<bool> checkRaceExists(String raceId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .get();

      final exists = snapshot.docs.isNotEmpty;

      return exists;
    } catch (e) {
      throw Exception('Failed to check races: $e');
    }
  }
}
