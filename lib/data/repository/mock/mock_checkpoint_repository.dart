import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';

class MockCheckpointRepository implements CheckpointRepository {
  final List<Checkpoint> _checkpoints = [
    Checkpoint(
      id: 1,
      bibNumber: 1001,
      raceId: 'r1',
      segment: RaceSegment.swimming,
      timeStamp: DateTime.now().add(Duration(minutes: 30)),
    ),
    Checkpoint(
      id: 2,
      bibNumber: 1003,
      raceId: 'r1',
      segment: RaceSegment.cycling,
      timeStamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
    ),
  ];

  @override
  Future<void> recordCheckpoint(Checkpoint checkpoint) async {
    _checkpoints.add(checkpoint);
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByRaceId(String raceId) async {
    return _checkpoints.where((c) => c.raceId == raceId).toList();
  }

  @override
  Future<List<Checkpoint>> getCheckpointsByParticipant(int bibNumber) async {
    return _checkpoints.where((c) => c.bibNumber == bibNumber).toList();
  }
}
