import 'package:flutter/material.dart';
import 'package:race_tracker_project/screens/manager_screens/dialogs/participant_form_dialog.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class GenderSelectionDialog extends StatelessWidget {
  final Function(String gender) onGenderSelected;

  const GenderSelectionDialog({super.key, required this.onGenderSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          'Select Participant Gender',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: RaceColors.primary),
        ),
      ),
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  width: 90,
                  text: 'Male',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ParticipantFormDialog(gender: 'Male'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                Button(
                  width: 90,
                  text: 'Female',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ParticipantFormDialog(gender: 'Female'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
