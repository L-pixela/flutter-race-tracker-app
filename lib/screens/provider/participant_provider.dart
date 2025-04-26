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
      // 1. Add data to repository
      await repository.addParticipant(participants);

      // 2. Fetch Data from repository
      await fetchParticipants();

      // 3. Handle Error
    } catch (e) {
      participant = AsyncValue.error(e);
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

  Future<void> deleteParticipant(int bibNumber) async {
    try {
      // 1. Delete from repository
      await repository.deleteParticipant(bibNumber);

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
}
