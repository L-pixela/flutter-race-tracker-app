import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'async_value.dart';

class CheckpointProvider extends ChangeNotifier {
  final CheckpointRepository repository;

  late AsyncValue<List<Checkpoint>> checkpoints;

  CheckpointProvider({required this.repository}) {
    checkpoints = AsyncValue.loading();
    fetchAllCheckpoint();
  }

  Future<void> fetchAllCheckpoint() async {
    checkpoints = AsyncValue.loading();
    notifyListeners();

    try {
      final data = await repository.fetchAllCheckpoints();
      checkpoints = AsyncValue.success(data);
    } catch (e) {
      checkpoints = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> fetchCheckpointByRaceId(String raceId) async {
    checkpoints = AsyncValue.loading();
    notifyListeners();

    try {
      final result = await repository.getCheckpointsByRaceId(raceId);
      checkpoints = AsyncValue.success(result);
    } catch (e) {
      checkpoints = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> fetchCheckpointByParticipant(int bibNumber) async {
    checkpoints = AsyncValue.loading();
    notifyListeners();

    try {
      final result = await repository.getCheckpointsByParticipant(bibNumber);
      checkpoints = AsyncValue.success(result);
    } catch (e) {
      checkpoints = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> recordCheckpoint(Checkpoint checkpoint) async {
    try {
      await repository.recordCheckpoint(checkpoint);

      await fetchCheckpointByRaceId(checkpoint.raceId);
    } catch (e) {
      checkpoints = AsyncValue.error(e);
    }
    notifyListeners();
  }
}
