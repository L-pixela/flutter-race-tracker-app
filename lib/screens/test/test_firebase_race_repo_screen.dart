import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/race/location.dart';
import 'package:race_tracker_project/model/race/race.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: TestFirebaseRaceRepoScreen()));
}

class TestFirebaseRaceRepoScreen extends StatefulWidget {
  const TestFirebaseRaceRepoScreen({super.key});

  @override
  State<TestFirebaseRaceRepoScreen> createState() =>
      _TestFirebaseRaceRepoScreenState();
}

class _TestFirebaseRaceRepoScreenState
    extends State<TestFirebaseRaceRepoScreen> {
  final FirebaseRaceRepository raceRepository = FirebaseRaceRepository();
  final TextEditingController raceIdController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final List<Race> races = [];

  Future<void> _createRace() async {
    final race = Race(
      raceId: raceIdController.text.trim(),
      raceEvent: eventNameController.text.trim(),
      raceStatus: RaceStatus.ongoing,
      location: const Location(name: 'Paris', region: Region.europe),
      date: DateTime.now(),
    );

    try {
      await raceRepository.createRace(race);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Race created successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create race: $e")),
      );
    }
  }

  Future<void> _loadRaces() async {
    try {
      final result = await raceRepository.getAllRaces();
      setState(() {
        races.clear();
        races.addAll(result);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load races: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Race Firestore Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: raceIdController,
              decoration: const InputDecoration(labelText: "Race ID"),
            ),
            TextField(
              controller: eventNameController,
              decoration: const InputDecoration(labelText: "Event Name"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _createRace,
                  child: const Text("Create Race"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _loadRaces,
                  child: const Text("Load All Races"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Race ID')),
                    DataColumn(label: Text('Event')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: races
                      .map((race) => DataRow(cells: [
                            DataCell(Text(race.raceId)),
                            DataCell(Text(race.raceEvent)),
                            DataCell(Text(race.location.name)),
                            DataCell(Text(race.raceStatus.label)),
                            DataCell(Text(race.date.toIso8601String())),
                          ]))
                      .toList(),
                ),
              ),
              // child: ListView.builder(
              //   itemCount: races.length,
              //   itemBuilder: (context, index) {
              //     final race = races[index];
              //     return ListTile(
              //       title: Text(race.raceEvent),
              //       subtitle: Text(
              //           "ID: ${race.raceId} | Location: ${race.location.name}"),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
