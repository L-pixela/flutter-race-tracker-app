import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/participant/participant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const ParticipantScreen(),
  ));
}

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  final FirebaseParticipantRepository _repository =
      FirebaseParticipantRepository();
  List<Participant> _participants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    setState(() => _isLoading = true);
    final participants = await _repository.getAllParticipants();
    setState(() {
      _participants = participants;
      _isLoading = false;
    });
  }

  Future<void> _addDummyParticipant() async {
    final participant = Participant(
      raceId: "R1",
      bibNumber: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      name: 'New Participant',
      gender: 'Other',
      participantStatus: ParticipantStatus.notStarted,
    );
    await _repository.addParticipant(participant);
    _loadParticipants(); // refresh the list
  }

  Future<void> _deleteParticipant(int bibNumber) async {
    await _repository.deleteParticipant(bibNumber);
    _loadParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Participants")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _participants.length,
              itemBuilder: (context, index) {
                final p = _participants[index];
                return ListTile(
                  title: Text("${p.name} (${p.bibNumber})"),
                  subtitle:
                      Text("Status: ${p.participantStatus?.label ?? 'N/A'}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteParticipant(p.bibNumber),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDummyParticipant,
        child: const Icon(Icons.add),
      ),
    );
  }
}
