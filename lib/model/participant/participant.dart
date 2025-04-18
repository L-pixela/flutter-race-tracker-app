///
/// Participant Status enum
///
enum ParticipantStatus { ongoing, notStarted, finished }

///
/// Participant class
///
class Participant {
  final int bibNumber;
  final String name;
  final String gender;
  final DateTime startDate;
  final DateTime finishDate;
  final ParticipantStatus participantStatus;

  const Participant(this.bibNumber, this.name, this.gender,
      this.participantStatus, this.startDate, this.finishDate);

  @override
  String toString() {
    return " Participant: {Bib: $bibNumber, Name: $name, Gender: $gender, Status: $participantStatus}";
  }
}
