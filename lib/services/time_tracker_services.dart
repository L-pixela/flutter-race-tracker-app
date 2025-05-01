import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';

class TimeTrackerServices extends ChangeNotifier {
  final CheckpointRepository checkpointRepository;

  RaceSegment? _selectedSegment;
  String? _activeRaceId;
  final Map<int, int> _participantTapCount = {}; // bibNumber -> tap count

  TimeTrackerServices({required this.checkpointRepository});

  // Initialize with current Race and segment
  void intialize({required String raceId, required RaceSegment segment}) {
    _activeRaceId = raceId;
    _selectedSegment = segment;
  }

  void onParticipantTap(int bibNumber) {
    _participantTapCount[bibNumber] =
        (_participantTapCount[bibNumber] ?? 0) + 1;

    if (_participantTapCount[bibNumber] == 1) {
      // First tap: Maybe mark participant started (optional)
      debugPrint('Participant $bibNumber started segment $_selectedSegment');
    } else if (_participantTapCount[bibNumber] == 2) {
      // Second tap: Save checkpoint
      _saveCheckpoint(bibNumber);
    }

    notifyListeners();
  }

  Future<void> _saveCheckpoint(int bibNumber) async {
    if (_activeRaceId == null || _selectedSegment == null) {
      debugPrint('Cannot save checkpoint without active race/segment');
      return;
    }

    final checkpoint = Checkpoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple unique id
      raceId: _activeRaceId!,
      bibNumber: bibNumber,
      segment: _selectedSegment!,
      timeStamp: DateTime.now(),
    );

    await checkpointRepository.recordCheckpoint(checkpoint);

    debugPrint(
        'Checkpoint saved for participant $bibNumber on segment $_selectedSegment');
  }

  void cancelCheckpoint(int bibNumber) {
    _participantTapCount.remove(bibNumber);
    notifyListeners();
  }

  bool isCheckpointCompleted(int bibNumber) {
    return _participantTapCount[bibNumber] == 2;
  }
}
