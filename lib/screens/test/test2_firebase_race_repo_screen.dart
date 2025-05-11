import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/theme/theme.dart';

void main() async {
  // 1. Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Repository for Provider
  ParticipantRepository participantRepository = FirebaseParticipantRepository();
  RaceRepository raceRepository = FirebaseRaceRepository();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ParticipantProvider(repository: participantRepository)),
        ChangeNotifierProvider(
            create: (context) => RaceProvider(repository: raceRepository))
      ],
      child: MaterialApp(
        home: TestRaceScreen(),
      )));
}

class TestRaceScreen extends StatelessWidget {
  const TestRaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final raceProvider = context.watch<RaceProvider>();
    final raceState = raceProvider.races;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Race Screen'),
        backgroundColor: RaceColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RaceProvider>().fetchRaceData();
            },
          )
        ],
      ),
      body: Builder(
        builder: (_) {
          if (raceState.state == AsyncValueState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (raceState.state == AsyncValueState.error) {
            return Center(
              child: Text(
                'Error: ${raceState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final races = raceState.data ?? [];

          if (races.isEmpty) {
            return const Center(child: Text('No races available.'));
          }

          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return ListTile(
                title: Text(race.raceEvent),
                subtitle: Text(race.location.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<RaceProvider>().deleteRace(race.raceId);
                  },
                ),
                onTap: () async {
                  // simulate update
                  final updatedRace = Race(
                    raceId: DateTime.now().millisecondsSinceEpoch.toString(),
                    raceStatus: RaceStatus.upcoming,
                    raceEvent: 'New Test Race Updated',
                    location: Location(
                        name: 'Test City',
                        region: Region.asia), // Adjust based on your Race model
                  );

                  await context.read<RaceProvider>().updateRace(updatedRace);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: RaceColors.primary,
        onPressed: () {
          // Simulate adding a new race
          final newRace = Race(
            raceId: 'R1',
            raceStatus: RaceStatus.upcoming,
            raceEvent: 'Dorney Evening Triathlon',
            location: Location(name: 'London', region: Region.europe),
          );
          context.read<RaceProvider>().addRace(newRace);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
