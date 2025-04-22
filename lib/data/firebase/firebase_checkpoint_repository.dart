import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/checkpoint_dto.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';

class FirebaseCheckpointRepository implements CheckpointRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'checkpoints';

  @override
  Future<void> recordCheckpoint(Checkpoint checkpoint) {
    try {
      final checkpointJson = CheckpointDto.toJson(checkpoint);
      return _firestore
          .collection(_collection)
          .doc(checkpoint.id.toString())
          .set(checkpointJson)
          .then((_) => print("Checkpoint added successfully"))
          .catchError((error) => print("Failed to add checkpoint: $error"));
    } catch (e) {
      throw Exception('Failed to add checkpoint: $e');
    }
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByParticipant(int bibNumber) {
    try {
      return _firestore
          .collection(_collection)
          .where('bibNumber', isEqualTo: bibNumber)
          .get()
          .then((snapshot) {
        print("Checkpoints fetched successfully");
        return snapshot.docs
            .map((doc) => CheckpointDto.fromJson(doc.data()))
            .toList();
      }).catchError((error) => print("Failed to fetch checkpoints: $error"));
    } catch (e) {
      throw Exception('Failed to fetch checkpoints: $e');
    }
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByRaceId(String raceId) {
    try {
      return _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .get()
          .then((snapshot) {
        print("Checkpoints fetched successfully");
        return snapshot.docs
            .map((doc) => CheckpointDto.fromJson(doc.data()))
            .toList();
      }).catchError((error) => print("Failed to fetch checkpoints: $error"));
    } catch (e) {
      throw Exception('Failed to fetch checkpoints: $e');
    }
  }
}
