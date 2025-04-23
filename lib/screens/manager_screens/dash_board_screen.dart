import 'package:flutter/material.dart';
import 'package:race_tracker_project/screens/manager_screens/dialogs/gender_selection_dialog.dart';
import 'package:race_tracker_project/screens/manager_screens/dialogs/participant_form_dialog.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: RaceColors.primary,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side buttons
            Row(
              children: [
                Button(
                  onPressed: () {
                    // View Participants logic
                  },
                  type: ButtonType.secondary,
                  text: 'Share',
                  icon: Icons.share_sharp,
                ),
                const SizedBox(width: 8),
                Button(
                  onPressed: () {
                    // Export Data logic
                  },
                  type: ButtonType.secondary,
                  text: 'Print',
                  icon: Icons.print,
                ),
              ],
            ),
            // Right side button
            Button(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GenderSelectionDialog(
                      onGenderSelected: (gender) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ParticipantFormDialog(gender: gender);
                          },
                        );
                      },
                    );
                  },
                );
              },
              text: 'Add Participant',
            ),
          ],
        ),
      ),
    );
  }
}
