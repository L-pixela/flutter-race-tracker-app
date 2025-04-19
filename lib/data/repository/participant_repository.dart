import 'package:race_tracker_project/model/participant/participant.dart';

abstract class ParticipantRepository {
  Future<void> addParticipant(Participant participant);
  Future<List<Participant>> getAllParticipants();
  Future<List<Participant>> searchParticipantByRaceId(String raceId);
  Future<void> updateParticipant(Participant participant);
  Future<void> deleteParticipant(int bibNumber);
  Future<Participant?> getParticipantByBibNumber(int bibNumber);
}
