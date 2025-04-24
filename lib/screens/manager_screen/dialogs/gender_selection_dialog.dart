import 'package:flutter/material.dart';

import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class GenderSelectionDialog extends StatelessWidget {
  const GenderSelectionDialog({super.key});

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
                    Navigator.pop(context, 'Male');
                  },
                ),
                const SizedBox(width: 20),
                Button(
                  width: 90,
                  text: 'Female',
                  onPressed: () {
                    Navigator.pop(context, 'Female');
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
