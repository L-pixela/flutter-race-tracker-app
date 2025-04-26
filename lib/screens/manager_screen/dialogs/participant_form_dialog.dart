// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart';

import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class ParticipantFormDialog extends StatefulWidget {
  final String gender;
  final Participant? participant;

  const ParticipantFormDialog(
      {super.key, required this.gender, required this.participant});

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
  late String raceId;

  @override
  void initState() {
    super.initState();
    _loadRaces();

    if (widget.participant != null) {
      raceId = widget.participant!.raceId;
      bibNumber = widget.participant!.bibNumber;
      name = widget.participant!.name;
    } else {
      bibNumber = 0;
      name = '';
      raceId = '';
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newParticipant = Participant(
          raceId: raceId,
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
      if (widget.participant != null) {
        // Select the race matching the participant
        _selectedRace = races.firstWhere(
          (race) => race.raceId == widget.participant!.raceId,
          orElse: () => races.first,
        );
      } else if (races.isNotEmpty) {
        // Default to first race for new participant
        _selectedRace = races.first;
        raceId = _selectedRace!.raceId;
      }
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

  String? _validateRace(Race? value) {
    if (value == null) {
      return 'Please select a race';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.participant != null;

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
                initialValue: isEditing ? bibNumber.toString() : null,
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
                enabled: !isEditing,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: isEditing ? name : null,
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
              const SizedBox(height: 16),
              DropdownButtonFormField<Race>(
                value: _selectedRace,
                decoration: InputDecoration(
                  labelText: 'Select Race',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: _races.map((race) {
                  return DropdownMenuItem(
                    value: race,
                    child: Text('${race.raceEvent} - ${race.location.name}'),
                  );
                }).toList(),
                onChanged: (race) => setState(() => _selectedRace = race),
                validator: _validateRace,
                onSaved: (value) => raceId = value!.raceId,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    onPressed: onSubmit,
                    text: isEditing ? 'Update' : 'Register',
                  ),
                  const SizedBox(width: 12),
                  Button(
                    onPressed: () {
                      if (isEditing) {
                        Navigator.pop(context);
                      } else {
                        _formKey.currentState?.reset();
                        setState(() {
                          bibNumber = 0;
                          name = '';
                          _selectedRace =
                              _races.isNotEmpty ? _races.first : null;
                        });
                      }
                    },
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
