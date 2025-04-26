import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';

class MockParticipantRepository implements ParticipantRepository {
  final Map<int, Participant> _participants = {
    1001: Participant(
      raceId: "R1",
      bibNumber: 1001,
      name: 'Alice Johnson',
      gender: 'F',
      participantStatus: ParticipantStatus.ongoing,
      startDate: DateTime.now(),
      finishDate: DateTime.now().add(Duration(hours: 1)),
    ),
    1002: Participant(
      raceId: "R1",
      bibNumber: 1002,
      name: 'Bob Smith',
      gender: 'M',
      participantStatus: ParticipantStatus.notStarted,
      startDate: DateTime.now(),
      finishDate: DateTime.now(),
    ),
    1003: Participant(
      raceId: "R1",
      bibNumber: 1003,
      name: 'Carlos Rivera',
      gender: 'M',
      participantStatus: ParticipantStatus.finished,
      startDate: DateTime.now().subtract(Duration(hours: 2)),
      finishDate: DateTime.now().subtract(Duration(hours: 1)),
    ),
  };

  @override
  Future<void> addParticipant(Participant participant) async {
    _participants[participant.bibNumber] = participant;
  }

  @override
  Future<List<Participant>> getAllParticipants() async =>
      _participants.values.toList();

  @override
  Future<List<Participant>> searchParticipantByRaceId(String raceId) async {
    // Not implemented in model, return all for now
    return _participants.values.toList();
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    _participants[participant.bibNumber] = participant;
  }

  @override
  Future<void> deleteParticipant(int bibNumber, String raceId) async {
    _participants.remove(bibNumber);
  }

  @override
  Future<Participant?> getParticipantByBibNumber(int bibNumber) async =>
      _participants[bibNumber];

  @override
  Future<bool> checkBibNumberExists(
      {required String raceId, required int bibNumber}) {
    // TODO: implement checkBibNumberExists
    throw UnimplementedError();
  }
}
