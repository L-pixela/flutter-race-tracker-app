import 'package:flutter/material.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class ParticipantFormDialog extends StatefulWidget {
  final String gender;

  const ParticipantFormDialog({super.key, required this.gender});

  @override
  _ParticipantFormDialogState createState() => _ParticipantFormDialogState();
}

class _ParticipantFormDialogState extends State<ParticipantFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bibController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bibController.dispose();
    super.dispose();
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
                controller: _bibController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Bib Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateBib,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Participant Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form is valid!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please complete the form correctly.'),
                          ),
                        );
                      }
                    },
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
