import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/checkpoint_dto.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';

class FirebaseCheckpointRepository implements CheckpointRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'checkpoints';

  @override
  Future<void> recordCheckpoint(Checkpoint checkpoint) async {
    try {
      final checkpointJson = CheckpointDto.toJson(checkpoint);
      await _firestore
          .collection(_collection)
          .doc(checkpoint.id.toString())
          .set(checkpointJson);
    } catch (e) {
      throw Exception('Failed to add checkpoint: $e');
    }
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByParticipant(int bibNumber) async {
    try {
      return await _firestore
          .collection(_collection)
          .where('bibNumber', isEqualTo: bibNumber)
          .get()
          .then((snapshot) {
        return snapshot.docs
            .map((doc) => CheckpointDto.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch checkpoints: $e');
    }
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByRaceId(String raceId) async {
    try {
      return await _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .get()
          .then((snapshot) {
        return snapshot.docs
            .map((doc) => CheckpointDto.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch checkpoints: $e');
    }
  }

  @override
  Future<void> deleteCheckpoint(String checkpointId) async {
    try {
      await _firestore.collection(_collection).doc(checkpointId).delete();
    } catch (e) {
      throw Exception("Falied to delete checkpoint: $e");
    }
  }

  @override
  Future<void> updateCheckpoint(Checkpoint newCheckpoint) async {
    try {
      final newCheckpointJson = CheckpointDto.toJson(newCheckpoint);

      await _firestore
          .collection(_collection)
          .doc(newCheckpoint.id)
          .set(newCheckpointJson);
    } catch (e) {
      throw Exception("Failed to update checkpoint: $e");
    }
  }
}
