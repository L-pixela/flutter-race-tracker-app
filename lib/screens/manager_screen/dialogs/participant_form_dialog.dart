import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart';

import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class ParticipantFormDialog extends StatefulWidget {
  final String gender;

  const ParticipantFormDialog({super.key, required this.gender});

  @override
  _ParticipantFormDialogState createState() => _ParticipantFormDialogState();
}

class _ParticipantFormDialogState extends State<ParticipantFormDialog> {
  final _raceRepo = FirebaseRaceRepository();
  List<Race> _races = [];
  Race? _selectedRace;

  final _formKey = GlobalKey<FormState>();
  late int bibNumber;
  late String name;

  @override
  void initState() {
    super.initState();
    _loadRaces();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newParticipant = Participant(
          raceId: _selectedRace!.raceId,
          bibNumber: bibNumber,
          name: name,
          gender: widget.gender);

      Navigator.pop(context, newParticipant);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form correctly.')),
      );
    }
  }

  Future<void> _loadRaces() async {
    final races = await _raceRepo.getAllRaces();
    setState(() {
      _races = races;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateBib(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter participant Bib number';
    }
    final bib = int.tryParse(value);
    if (bib == null || bib < 0) {
      return 'Please enter a valid Bib number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: RaceColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${widget.gender} Participant',
          style: const TextStyle(color: RaceColors.white),
        ),
        backgroundColor: RaceColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Bib Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: _validateBib,
                onSaved: (value) => bibNumber = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Participant Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateName,
                onSaved: (value) => name = value!.trim(),
              ),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    onPressed: onSubmit,
                    text: 'Register',
                  ),
                  const SizedBox(width: 12),
                  Button(
                    onPressed: () {},
                    text: 'Cancel',
                    type: ButtonType.secondary,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
