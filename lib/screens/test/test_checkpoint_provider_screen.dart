import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/data/firebase/firebase_checkpoint_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/race_segment/checkpoint.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';
import 'package:race_tracker_project/screens/provider/checkpoint_provider.dart';

void main() async {
  // 1. Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          CheckpointProvider(repository: FirebaseCheckpointRepository()),
      child: MaterialApp(
        home: TestCheckpointProviderScreen(),
      ),
    ),
  );
}

class TestCheckpointProviderScreen extends StatelessWidget {
  final String raceId = "R1";

  const TestCheckpointProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CheckpointProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkpoint Test")),
      body: Consumer<CheckpointProvider>(
          builder: (context, checkpointProvider, _) {
        final state = checkpointProvider.checkpoints.state;

        switch (state) {
          case AsyncValueState.loading:
            return Center(child: CircularProgressIndicator());
          case AsyncValueState.error:
            return Center(
              child: Text("Error: ${checkpointProvider.checkpoints.error}"),
            );
          case AsyncValueState.success:
            final checkpoints = checkpointProvider.checkpoints.data;
            if (checkpoints!.isEmpty) {
              return const Text("No data");
            }

            return ListView.builder(
              itemCount: checkpoints.length,
              itemBuilder: (context, index) {
                final cp = checkpoints[index];
                return ListTile(
                  title: Text("Checkpoint ${cp.id}"),
                  subtitle:
                      Text("Bib: ${cp.bibNumber} | Time: ${cp.startTime}"),
                );
              },
            );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newCheckpoint = Checkpoint(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              raceId: raceId,
              bibNumber: 2,
              startTime: DateTime.now(),
              segment: RaceSegment.swimming);

          provider.recordCheckpoint(newCheckpoint);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
