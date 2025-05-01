import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/data/firebase/firebase_checkpoint_repository.dart';
import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/services/time_tracker_services.dart';

void main() async {
  // 1. Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Repository for Provider
  ParticipantRepository participantRepository = FirebaseParticipantRepository();
  RaceRepository raceRepository = FirebaseRaceRepository();
  CheckpointRepository checkpointRepository = FirebaseCheckpointRepository();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ParticipantProvider(repository: participantRepository)),
        ChangeNotifierProvider(
            create: (context) => RaceProvider(repository: raceRepository)),
        ChangeNotifierProvider(
            create: (context) =>
                TimeTrackerServices(checkpointRepository: checkpointRepository))
      ],
      child: MaterialApp(
        home: TimeTrackerTestScreen(),
      )));
}

class TimeTrackerTestScreen extends StatefulWidget {
  const TimeTrackerTestScreen({super.key});

  @override
  State<TimeTrackerTestScreen> createState() => _TimeTrackerTestScreenState();
}

class _TimeTrackerTestScreenState extends State<TimeTrackerTestScreen> {
  RaceSegment? selectedSegment;

  // Fake participants
  final List<int> participantBibNumbers = [101, 102, 103, 104];

  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<TimeTrackerServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker Test'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Segment Selector
          DropdownButton<RaceSegment>(
            value: selectedSegment,
            hint: const Text('Select Race Segment'),
            items: RaceSegment.values.map((segment) {
              return DropdownMenuItem<RaceSegment>(
                value: segment,
                child: Text(segment.label),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSegment = value;
              });
              if (value != null) {
                tracker.intialize(
                  raceId: "race123", // hardcoded for now
                  segment: value,
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: participantBibNumbers.length,
              itemBuilder: (context, index) {
                final bib = participantBibNumbers[index];
                final isCompleted = tracker.isCheckpointCompleted(bib);

                return ListTile(
                  title: Text('Bib #$bib'),
                  trailing: ElevatedButton(
                    onPressed: isCompleted
                        ? null
                        : () {
                            tracker.onParticipantTap(bib);
                          },
                    onLongPress: () {
                      tracker.cancelCheckpoint(bib);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? Colors.grey : Colors.blue,
                    ),
                    child: Text(isCompleted ? 'Completed' : 'Tap'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
