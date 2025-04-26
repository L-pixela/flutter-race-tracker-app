import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';

///
/// Participant Provider
///
class ParticipantProvider extends ChangeNotifier {
  final ParticipantRepository repository;

  late AsyncValue<List<Participant>> participant;

  ParticipantProvider({required this.repository}) {
    participant = AsyncValue.loading();
    fetchParticipants();
  }

  Future<void> addParticipant(Participant participants) async {
    try {
      // 1. Check if bib number exists
      bool exists = await repository.checkBibNumberExists(
          raceId: participants.raceId, bibNumber: participants.bibNumber);

      if (exists) {
        throw Exception(
            "Bib number already exists. Please choose a different number.");
      }

      // 2. Add the data
      await repository.addParticipant(participants);

      // 3. Fetch Data from repository
      await fetchParticipants();

      // 4. Handle Error
    } catch (e) {
      participant = AsyncValue.error(e);
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchParticipants() async {
    // 1. Handle the Loading
    participant = AsyncValue.loading();
    notifyListeners();

    try {
      // 2. Fetch Participants from repository
      List<Participant> participants = await repository.getAllParticipants();

      // 3. Handle Success
      participant = AsyncValue.success(participants);

      // 4- Hanles Error
    } catch (e) {
      participant = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> deleteParticipant(int bibNumber, String raceId) async {
    try {
      // 1. Delete from repository
      await repository.deleteParticipant(bibNumber, raceId);

      // 2. Refresh the list after deletion
      await fetchParticipants();

      // 3. Handle the error
    } catch (e) {
      participant = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> updateParticipant(Participant participantToUpdate) async {
    try {
      // 1. Update Participant in repository
      await repository.updateParticipant(participantToUpdate);

      // 2. Refresh the list after update
      await fetchParticipants();
    } catch (e) {
      participant = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<bool> checkbibNumberExist(String raceId, int bibNumber) async {
    try {
      // 1. Check the data if it exists
      return await repository.checkBibNumberExists(
          raceId: raceId, bibNumber: bibNumber);
    } catch (e) {
      participant = AsyncValue.error(e);
      notifyListeners();
      return false;
    }
  }
}
