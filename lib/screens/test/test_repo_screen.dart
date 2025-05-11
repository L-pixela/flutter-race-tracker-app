import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/repository/mock/mock_checkpoint_repository.dart';
import 'package:race_tracker_project/data/repository/mock/mock_participant_repository.dart';
import 'package:race_tracker_project/data/repository/mock/mock_race_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';

void main() {
  runApp(const MaterialApp(
    home: TestMockRepoScreen(),
  ));
}

class TestMockRepoScreen extends StatefulWidget {
  const TestMockRepoScreen({super.key});

  @override
  State<TestMockRepoScreen> createState() => _TestMockRepoScreenState();
}

class _TestMockRepoScreenState extends State<TestMockRepoScreen> {
  final _raceRepo = MockRaceRepository();
  final _participantRepo = MockParticipantRepository();
  final _checkpointRepo = MockCheckpointRepository();

  late Future<List<Race>> _racesFuture;
  late Future<List<Participant>> _participantsFuture;
  late Future<List<Checkpoint>> _checkpointsFuture;

  @override
  void initState() {
    super.initState();
    _racesFuture = _raceRepo.getAllRaces();
    _participantsFuture = _participantRepo.getAllParticipants();
    _checkpointsFuture = _checkpointRepo.getCheckpointsByRaceId("r1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mock Repositories Test")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Races",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Race>>(
                future: _racesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!
                        .map((race) => ListTile(
                              title: Text(race.raceEvent),
                              subtitle: Text(
                                  "Status: ${race.raceStatus}, Location: ${race.location.name}"),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text("Participants",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Participant>>(
                future: _participantsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!
                        .map((p) => ListTile(
                              title: Text(p.name),
                              subtitle: Text(
                                  "Bib: ${p.bibNumber} - Status: ${p.participantStatus?.label}"),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text("Checkpoints for r1",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<List<Checkpoint>>(
                future: _checkpointsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!
                        .map((c) => ListTile(
                              title: Text(
                                  "${c.raceId} - ${c.bibNumber} - ${c.segment.label}"),
                              subtitle: Text("Time: ${c.startTime}"),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
