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
  final int bibNumber;
  final String name;
  final String gender;
  final DateTime? startDate;
  final DateTime? finishDate;
  final ParticipantStatus participantStatus;

  const Participant(
      {required this.bibNumber,
      required this.name,
      required this.gender,
      required this.participantStatus,
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
