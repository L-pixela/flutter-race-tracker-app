import 'package:flutter/material.dart';

import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';

class TimeTrackerServices extends ChangeNotifier {
  final CheckpointRepository checkpointRepository;
  final ParticipantProvider participantProvider;

  RaceSegment? _selectedSegment;
  String? _activeRaceId;
  final Map<int, int> _participantTapCount = {}; // bibNumber -> tap count
  final Map<int, DateTime> _raceStartTimes = {};
  final Map<int, DateTime> _raceFinishTimes = {};
  final Map<String, Checkpoint> _checkpoints = {};

  TimeTrackerServices(
      {required this.checkpointRepository, required this.participantProvider});

  // Initialize with current Race and segment
  void intialize({required String raceId, required RaceSegment segment}) {
    if (_selectedSegment != segment) {
      _participantTapCount.clear(); // prevent incorrect continuity
    }
    _activeRaceId = raceId;
    _selectedSegment = segment;
  }

  Future<void> onParticipantTap(int bibNumber) async {
    _participantTapCount[bibNumber] =
        (_participantTapCount[bibNumber] ?? 0) + 1;

    final tapCount = _participantTapCount[bibNumber]!;
    final isFirstSegment = _selectedSegment == RaceSegment.swimming;
    final isLastSegment = _selectedSegment == RaceSegment.running;

    if (tapCount == 1) {
      await _saveCheckpoint(bibNumber);
      // Record race start time if on first segment
      if (isFirstSegment) {
        _raceStartTimes[bibNumber] = DateTime.now();

        // Save to participant model
        final participant = participantProvider.getParticipantByBib(bibNumber);
        if (participant == null) return;

        final updated = Participant(
            raceId: participant.raceId,
            bibNumber: participant.bibNumber,
            name: participant.name,
            gender: participant.gender,
            participantStatus: ParticipantStatus.ongoing,
            startDate: DateTime.now());
        await participantProvider.updateParticipant(updated);
      }
      debugPrint('Start of segment $_selectedSegment for BIB $bibNumber');
    } else if (tapCount == 2) {
      await _saveCheckpoint(bibNumber);

      // Record race finish time if on last segment
      if (isLastSegment) {
        _raceFinishTimes[bibNumber] = DateTime.now();
        debugPrint('Finish of race for BIB $bibNumber');

        // Save to participant model
        final participant = participantProvider.getParticipantByBib(bibNumber);
        if (participant == null) return;

        final updated = Participant(
            raceId: participant.raceId,
            bibNumber: participant.bibNumber,
            name: participant.name,
            gender: participant.gender,
            participantStatus: ParticipantStatus.finished,
            startDate: participant.startDate,
            finishDate: DateTime.now());
        await participantProvider.updateParticipant(updated);
      }
    }

    notifyListeners();
  }

  DateTime? getRaceStartTime(int bibNumber) => _raceStartTimes[bibNumber];
  DateTime? getRaceFinishTime(int bibNumber) => _raceFinishTimes[bibNumber];

  Future<void> _saveCheckpoint(int bibNumber) async {
    if (_activeRaceId == null || _selectedSegment == null) return;

    final key = '${_selectedSegment!}_$bibNumber';
    final tapCount = _participantTapCount[bibNumber] ?? 0;

    if (tapCount == 1) {
      // First tap ➝ save start time only
      final checkpoint = Checkpoint(
        id: key,
        raceId: _activeRaceId!,
        bibNumber: bibNumber,
        segment: _selectedSegment!,
        startTime: DateTime.now(),
      );

      _checkpoints[key] = checkpoint;
      await checkpointRepository.recordCheckpoint(checkpoint);
      debugPrint('Started segment $_selectedSegment for BIB $bibNumber');
    } else if (tapCount == 2 && _checkpoints.containsKey(key)) {
      // Second tap ➝ update checkpoint with endTime
      final updated = _checkpoints[key]!;
      final completedCheckpoint = Checkpoint(
        id: updated.id,
        raceId: updated.raceId,
        bibNumber: updated.bibNumber,
        segment: updated.segment,
        startTime: updated.startTime,
        endTime: DateTime.now(),
      );

      _checkpoints[key] = completedCheckpoint;
      await checkpointRepository.updateCheckpoint(completedCheckpoint);
      debugPrint('Finished segment $_selectedSegment for BIB $bibNumber');
    }
  }

  Future<void> undoLastTap(int bibNumber) async {
    final tapCount = _participantTapCount[bibNumber] ?? 0;
    if (tapCount == 0) return;

    final key = '${_selectedSegment!}_$bibNumber';

    if (tapCount == 2) {
      // Undo endTime
      final checkpoint = _checkpoints[key];
      if (checkpoint != null) {
        final reverted = Checkpoint(
          id: checkpoint.id,
          raceId: checkpoint.raceId,
          bibNumber: checkpoint.bibNumber,
          segment: checkpoint.segment,
          startTime: checkpoint.startTime,
          endTime: null,
        );
        _checkpoints[key] = reverted;
        await checkpointRepository.updateCheckpoint(reverted);
        debugPrint(
            'Undo finish for segment $_selectedSegment for BIB $bibNumber');
      }

      if (_selectedSegment == RaceSegment.running) {
        _raceFinishTimes.remove(bibNumber);
        final participant = participantProvider.getParticipantByBib(bibNumber);
        if (participant != null) {
          final updated = Participant(
            raceId: participant.raceId,
            bibNumber: participant.bibNumber,
            name: participant.name,
            gender: participant.gender,
            participantStatus: ParticipantStatus.ongoing,
            startDate: participant.startDate,
            finishDate: null,
          );
          await participantProvider.updateParticipant(updated);
        }
      }
    } else if (tapCount == 1) {
      // Undo startTime
      _checkpoints.remove(key);
      await checkpointRepository.deleteCheckpoint(key);
      debugPrint('Undo start for segment $_selectedSegment for BIB $bibNumber');

      if (_selectedSegment == RaceSegment.swimming) {
        _raceStartTimes.remove(bibNumber);
        final participant = participantProvider.getParticipantByBib(bibNumber);
        if (participant != null) {
          final updated = Participant(
            raceId: participant.raceId,
            bibNumber: participant.bibNumber,
            name: participant.name,
            gender: participant.gender,
            participantStatus: ParticipantStatus.notStarted,
          );
          await participantProvider.updateParticipant(updated);
        }
      }
    }

    _participantTapCount[bibNumber] = tapCount - 1;
    notifyListeners();
  }

  void cancelCheckpoint(int bibNumber) {
    _participantTapCount.remove(bibNumber);
    notifyListeners();
  }

  void resetParticipant(int bibNumber) {
    _participantTapCount.remove(bibNumber);
    _raceStartTimes.remove(bibNumber);
    _raceFinishTimes.remove(bibNumber);
    notifyListeners();
  }

  bool isCheckpointCompleted(int bibNumber) {
    return _participantTapCount[bibNumber] == 2;
  }
}
