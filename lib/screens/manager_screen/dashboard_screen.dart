// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/screens/manager_screen/dialogs/gender_selection_dialog.dart';
import 'package:race_tracker_project/screens/manager_screen/dialogs/participant_form_dialog.dart';
import 'package:race_tracker_project/screens/manager_screen/widgets/participant_tile.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';
import 'package:race_tracker_project/widgets/navigation_bar.dart';

///
/// This is the Dashboard Screen for Race Manager to see the participants
/// While also Having CRUD Participants
///
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void handleAddParticipant(BuildContext context) async {
    final gender = await showDialog<String>(
      context: context,
      builder: (_) => GenderSelectionDialog(),
    );

    if (gender != null) {
      final newParticipant = await showDialog<Participant>(
          context: context,
          builder: (_) => ParticipantFormDialog(gender: gender));

      if (newParticipant != null) {
        context.read<ParticipantProvider>().addParticipant(newParticipant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = context.watch<ParticipantProvider>();

    return Scaffold(
      bottomNavigationBar: Navigation_Bar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: RaceColors.primary,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row with search bar and button
                  Row(
                    children: [
                      // Short search bar
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Button Go to Tracker

                      Button(
                        onPressed: () {
                          // Export Data logic
                        },
                        type: ButtonType.secondary,
                        text: 'Tracker',
                        icon: Icons.timer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
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
                  onPressed: () => handleAddParticipant(context),
                  text: 'Add Participant',
                ),
              ],
            ),
            const SizedBox(height: 16), // spacing between row and list
            Expanded(
              child: _buildParticipantListView(participantProvider, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantListView(
      ParticipantProvider provider, BuildContext context) {
    final participantValue = provider.participant;

    switch (participantValue.state) {
      case AsyncValueState.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      case AsyncValueState.error:
        return Text('Error: ${participantValue.error}');
      case AsyncValueState.success:
        if (participantValue.data == null || participantValue.data!.isEmpty) {
          return Center(
            child: Text("No Participant Registered Yet!"),
          );
        }

        return ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: participantValue.data!.length,
            itemBuilder: (ctx, index) => ParticipantTile(
                  onTap: () {},
                  participant: participantValue.data![index],
                  onEdit: () {},
                  onDelete: () {},
                ));
    }
  }
}
