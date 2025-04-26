import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracker_project/data/dto/participant_dto.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';

class FirebaseParticipantRepository implements ParticipantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'participants';

  @override
  Future<void> addParticipant(Participant participant) async {
    try {
      final participantJson = ParticipantDto.toJson(participant);
      await _firestore.collection(_collection).add(participantJson);
    } catch (e) {
      throw Exception('Failed to add participant: $e');
    }
  }

  @override
  Future<void> deleteParticipant(int bibNumber, String raceId) async {
    try {
      // Find the data where it match the bibNumber and raceId
      final querySnapShot = await _firestore
          .collection(_collection)
          .where('bibNumber', isEqualTo: bibNumber)
          .where('raceId', isEqualTo: raceId)
          .limit(1)
          .get();
      // check for the doc if it is empty
      if (querySnapShot.docs.isEmpty) {
        throw Exception('Participant not found for deletion');
      }
      // get the docId
      final docId = querySnapShot.docs.first.id;
      // Perform the deletion
      await _firestore.collection(_collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete participant: $e');
    }
  }

  @override
  Future<List<Participant>> getAllParticipants() async {
    try {
      return _firestore.collection(_collection).get().then((snapshot) {
        return snapshot.docs
            .map((doc) => ParticipantDto.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to fetch participants: $e');
    }
  }

  @override
  Future<List<Participant>> searchParticipantByRaceId(String raceId) async {
    try {
      return await _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .get()
          .then((snapshot) {
        return snapshot.docs
            .map((doc) => ParticipantDto.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to search participants by raceId: $e');
    }
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('bibNumber', isEqualTo: participant.bibNumber)
          .where('raceId', isEqualTo: participant.raceId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Participant not found!');
      }
      final docId = querySnapshot.docs.first.id;

      final participantJson = ParticipantDto.toJson(participant);

      await _firestore
          .collection(_collection)
          .doc(docId)
          .update(participantJson);
    } catch (e) {
      throw Exception('Failed to update participant: $e');
    }
  }

  @override
  Future<bool> checkBibNumberExists(
      {required String raceId, required int bibNumber}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('raceId', isEqualTo: raceId)
          .where('bibNumber', isEqualTo: bibNumber)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check Bib number existence: $e');
    }
  }
}
