import 'package:race_tracker_project/model/participant/participant.dart';

class ParticipantDto {
  static Map<String, dynamic> toJson(Participant model) {
    return {
      'raceId': model.raceId,
      'bibNumber': model.bibNumber,
      'name': model.name,
      'gender': model.gender,
      'startDate': model.startDate?.toIso8601String(),
      'endDate': model.finishDate?.toIso8601String(),
      'status': model.participantStatus?.label
    };
  }

  static Participant fromJson(Map<String, dynamic> json) {
    return Participant(
        raceId: json['raceId'],
        bibNumber: json['bibNumber'],
        name: json['name'],
        gender: json['gender'],
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : null,
        finishDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        participantStatus: statusFromString(json['status']));
  }

  static ParticipantStatus statusFromString(String value) {
    return ParticipantStatus.values.firstWhere(
        (status) => status.label == value,
        orElse: () => throw Exception('Invalid status value: $value'));
  }
}
