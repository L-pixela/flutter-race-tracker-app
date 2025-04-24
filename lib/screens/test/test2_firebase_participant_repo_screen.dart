import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart'; // Adjust import to your structure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: ParticipantForm()));
}

class ParticipantForm extends StatefulWidget {
  const ParticipantForm({super.key});

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _participantRepo = FirebaseParticipantRepository();
  final _raceRepo = FirebaseRaceRepository();

  List<Race> _races = [];
  Race? _selectedRace;

  final _nameController = TextEditingController();
  final _bibController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRaces();
  }

  Future<void> _loadRaces() async {
    final races = await _raceRepo.getAllRaces();
    setState(() {
      _races = races;
    });
  }

  void _submitForm() async {
    if (_selectedRace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a race.')),
      );
      return;
    }

    final bib = int.tryParse(_bibController.text);
    if (bib == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid bib number.')),
      );
      return;
    }

    final participant = Participant(
      race: _selectedRace!,
      bibNumber: bib,
      name: _nameController.text,
      gender: _genderController.text,
    );

    await _participantRepo.addParticipant(participant);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Participant added successfully!')),
    );

    // Clear form
    _nameController.clear();
    _bibController.clear();
    _genderController.clear();
    setState(() => _selectedRace = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Participant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Race>(
              value: _selectedRace,
              decoration: const InputDecoration(labelText: 'Select Race'),
              items: _races.map((race) {
                return DropdownMenuItem(
                  value: race,
                  child: Text('${race.raceEvent} - ${race.location.name}'),
                );
              }).toList(),
              onChanged: (race) => setState(() => _selectedRace = race),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Participant Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bibController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Bib Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
