///
/// Participant Status enum
///
enum ParticipantStatus {
  ongoing('Ongoing'),
  notStarted('Not Started'),
  finished('Finished');

  final String label;

  const ParticipantStatus(this.label);
}

///
/// Participant class
///
class Participant {
  final String raceId;
  final int bibNumber;
  final String name;
  final String gender;
  final DateTime? startDate;
  final DateTime? finishDate;
  final ParticipantStatus? participantStatus;

  const Participant(
      {required this.raceId,
      required this.bibNumber,
      required this.name,
      required this.gender,
      this.participantStatus = ParticipantStatus.notStarted,
      this.startDate,
      this.finishDate});

  bool get isOngoing => participantStatus == ParticipantStatus.ongoing;
  bool get isNotStarted => participantStatus == ParticipantStatus.notStarted;
  bool get isFinished => participantStatus == ParticipantStatus.finished;

  @override
  String toString() {
    return " Participant: {Bib: $bibNumber, Name: $name, Gender: $gender, Status: $participantStatus}";
  }
}
