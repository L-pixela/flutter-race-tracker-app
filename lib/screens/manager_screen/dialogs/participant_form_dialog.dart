// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';

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
  Race? _selectedRace;

  final _formKey = GlobalKey<FormState>();
  late int bibNumber;
  late String name;
  late String raceId;

  @override
  void initState() {
    super.initState();

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSelectedRace();
  }

  void _initializeSelectedRace() {
    final raceState = context.watch<RaceProvider>().races;

    if (_selectedRace == null &&
        widget.participant != null &&
        raceState.state == AsyncValueState.success &&
        raceState.data != null &&
        raceState.data!.isNotEmpty) {
      final allRaces = raceState.data!;
      _selectedRace = allRaces.firstWhere(
        (race) => race.raceId == widget.participant!.raceId,
        orElse: () => allRaces.first,
      );
      raceId = _selectedRace!.raceId;
      setState(
          () {}); // <- Important! Force widget to rebuild with new _selectedRace
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void onSubmit() async {
    // Handle the form validation
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form correctly.')),
      );
      return;
    }
    // after validating save the form value
    _formKey.currentState!.save();

    // check if the bibNumber of participant already exist
    // if not can add new participant
    bool exists = await context
        .read<ParticipantProvider>()
        .checkbibNumberExist(raceId, bibNumber);

    final isEditing = widget.participant != null;

    if (exists && !isEditing) {
      // Only show error if it's a new participant, not editing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bib number already exists! Please choose another.')),
      );
      return;
    }

    // create the Participant
    final newParticipant = Participant(
        raceId: raceId,
        bibNumber: bibNumber,
        name: name,
        gender: widget.gender);
    // Return data with pop
    Navigator.pop(context, newParticipant);
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
    final raceProvider = context.watch<RaceProvider>();
    final raceState = raceProvider.races;
    final isEditing = widget.participant != null;

    if (raceState == AsyncValue.loading()) {
      return const Center(child: CircularProgressIndicator());
    }
    final availableRaces = raceState.data ?? [];

    if (_selectedRace == null && availableRaces.isNotEmpty) {
      _selectedRace = availableRaces.first;
    }

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
                items: availableRaces.map((race) {
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
                          _selectedRace = raceState.data!.isNotEmpty
                              ? raceState.data!.first
                              : null;
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
