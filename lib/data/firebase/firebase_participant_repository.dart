import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/participant_dto.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';

class FirebaseParticipantRepository implements ParticipantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'participants';

  @override
  Future<void> addParticipant(Participant participant) {
    try {
      final participantJson = ParticipantDto.toJson(participant);
      return _firestore
          .collection(_collection)
          .doc(participant.bibNumber.toString())
          .set(participantJson)
          .then((_) => print("Participant added successfully"))
          .catchError((error) => print("Failed to add participant: $error"));
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> deleteParticipant(int bibNumber) {
    try {
      return _firestore
          .collection(_collection)
          .doc(bibNumber.toString())
          .delete()
          .then((_) => print("Participant deleted successfully"))
          .catchError((error) => print("Failed to delete participant: $error"));
    } catch (e) {
      throw Exception('Failed to delete participant: $e');
    }
  }

  @override
  Future<List<Participant>> getAllParticipants() {
    try {
      return _firestore.collection(_collection).get().then((snapshot) {
        print("Participants fetched successfully");
        return snapshot.docs
            .map((doc) => ParticipantDto.fromJson(doc.data()))
            .toList();
      }).catchError((error) => print("Failed to fetch participants: $error"));
    } catch (e) {
      throw Exception('Failed to fetch participants: $e');
    }
  }

  @override
  Future<Participant?> getParticipantByBibNumber(int bibNumber) {
    try {
      return _firestore
          .collection(_collection)
          .doc(bibNumber.toString())
          .get()
          .then((doc) {
        if (doc.exists) {
          print("Participant fetched successfully");
          return ParticipantDto.fromJson(doc.data()!);
        }
        return null;
      }).catchError((error) => print("Failed to fetch participant: $error"));
    } catch (e) {
      throw Exception('Failed to fetch participant: $e');
    }
  }

  @override
  Future<List<Participant>> searchParticipantByRaceId(String raceId) {
    try {
      return _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .get()
          .then((snapshot) {
        print("Participants searched by raceId successfully");
        return snapshot.docs
            .map((doc) => ParticipantDto.fromJson(doc.data()))
            .toList();
      }).catchError((error) =>
              print("Failed to search participants by raceId: $error"));
    } catch (e) {
      throw Exception('Failed to search participants by raceId: $e');
    }
  }

  @override
  Future<void> updateParticipant(Participant participant) {
    try {
      final participantJson = ParticipantDto.toJson(participant);
      return _firestore
          .collection(_collection)
          .doc(participant.bibNumber.toString())
          .set(participantJson)
          .then((_) => print("Participant updated successfully"))
          .catchError((error) => print("Failed to update participant: $error"));
    } catch (e) {
      throw Exception('Failed to update participant: $e');
    }
  }
}
