import 'package:flutter_test/flutter_test.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/data/dto/participant_dto.dart';

void main() {
  // Define a common test participant
  Participant testParticipant = Participant(
    bibNumber: 42,
    name: "Test Runner",
    gender: "Male",
    startDate: DateTime(2023, 1, 1, 9, 0),
    finishDate: DateTime(2023, 1, 1, 10, 30),
    participantStatus: ParticipantStatus.finished,
  );

  group('Participant DTO Tests', () {
    test('should convert Participant to JSON correctly', () {
      // When
      final json = ParticipantDto.toJson(testParticipant);

      // Then
      expect(json, {
        'bibNumber': 42,
        'name': 'Test Runner',
        'gender': 'Male',
        'startDate': '2023-01-01T09:00:00.000',
        'endDate': '2023-01-01T10:30:00.000',
        'status': 'Finished'
      });
    });

    test('should convert JSON to Participant correctly', () {
      // Given
      final json = {
        'bibNumber': 42,
        'name': 'Test Runner',
        'gender': 'Male',
        'startDate': '2023-01-01T09:00:00.000',
        'endDate': '2023-01-01T10:30:00.000',
        'status': 'Finished'
      };

      // When
      final result = ParticipantDto.fromJson(json);

      // Then
      expect(result.bibNumber, testParticipant.bibNumber);
      expect(result.name, testParticipant.name);
      expect(result.gender, testParticipant.gender);
      expect(result.startDate, testParticipant.startDate);
      expect(result.finishDate, testParticipant.finishDate);
      expect(result.participantStatus, testParticipant.participantStatus);
    });

    test('should handle all status enum cases', () {
      // Valid cases
      expect(ParticipantDto.statusFromString('Ongoing'),
          ParticipantStatus.ongoing);
      expect(ParticipantDto.statusFromString('Not Started'),
          ParticipantStatus.notStarted);
      expect(ParticipantDto.statusFromString('Finished'),
          ParticipantStatus.finished);

      // Invalid case
      expect(() => ParticipantDto.statusFromString('InvalidStatus'),
          throwsA(isA<Exception>()));
    });
  });

  group('Participant Model Tests', () {
    test('should have correct string representation', () {
      // When
      final stringRep = testParticipant.toString();

      // Then
      expect(stringRep, contains('Participant: {'));
      expect(stringRep, contains('Bib: 42'));
      expect(stringRep, contains('Name: Test Runner'));
      expect(stringRep, contains('Status: ParticipantStatus.finished'));
    });
  });
}
