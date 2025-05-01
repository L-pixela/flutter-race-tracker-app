import 'package:race_tracker_project/model/race_segment/checkpoint.dart';

abstract class CheckpointRepository {
  Future<void> recordCheckpoint(Checkpoint checkpoint);
  Future<void> updateCheckpoint(Checkpoint newCheckpoint);
  Future<void> deleteCheckpoint(String id);
  Future<List<Checkpoint>> getCheckpointsByRaceId(String raceId);
  Future<List<Checkpoint>> getCheckpointsByParticipant(int bibNumber);
}
