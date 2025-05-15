// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/model/participant/participant.dart';
import 'package:race_tracker_project/screens/manager_screen/dialogs/gender_selection_dialog.dart';
import 'package:race_tracker_project/screens/manager_screen/dialogs/participant_form_dialog.dart';
import 'package:race_tracker_project/screens/manager_screen/widgets/participant_tile.dart';
import 'package:race_tracker_project/screens/provider/async_value.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/segment_selection_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

///
/// This is the Dashboard Screen for Race Manager to see the participants
/// While also Having CRUD Participants
///
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchQuery = '';

  void handleAddParticipant(BuildContext context) async {
    final gender = await showDialog<String>(
      context: context,
      builder: (_) => GenderSelectionDialog(),
    );

    if (gender != null) {
      final newParticipant = await showDialog<Participant>(
        context: context,
        builder: (_) => ParticipantFormDialog(
          gender: gender,
          participant: null,
        ),
      );

      if (newParticipant != null) {
        context.read<ParticipantProvider>().addParticipant(newParticipant);
      }
    }
  }

  void handleDeleteParticipant(Participant participant) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Delete Participant"),
              content:
                  Text("Are you sure you want to delete ${participant.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ));

    if (confirm == true) {
      context
          .read<ParticipantProvider>()
          .deleteParticipant(participant.bibNumber, participant.raceId);
    }
  }

  void handleEditParticipant(Participant participant) async {
    final updateParticipant = await showDialog<Participant>(
        context: context,
        builder: (ctx) => ParticipantFormDialog(
              gender: participant.gender,
              participant: participant,
            ));

    if (updateParticipant != null) {
      context.read<ParticipantProvider>().updateParticipant(updateParticipant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = context.watch<ParticipantProvider>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: RaceColors.primary,
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.trim().toLowerCase();
                              });
                            },
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
                      Button(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SegmentSelectionScreen(),
                            ),
                          );
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
                Row(
                  children: [
                    Button(
                      onPressed: () {},
                      type: ButtonType.secondary,
                      text: 'Share',
                      icon: Icons.share_sharp,
                    ),
                    const SizedBox(width: 8),
                    Button(
                      onPressed: () {},
                      type: ButtonType.secondary,
                      text: 'Print',
                      icon: Icons.print,
                    ),
                  ],
                ),
                Button(
                  onPressed: () => handleAddParticipant(context),
                  text: 'Add Participant',
                ),
              ],
            ),
            const SizedBox(height: 16),
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
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Error: ${participantValue.error}');
      case AsyncValueState.success:
        final data = participantValue.data;
        if (data == null || data.isEmpty) {
          return const Center(child: Text("No Participant Registered Yet!"));
        }

        // Filter and sort participants
        final filtered = data.where((p) =>
            p.name.toLowerCase().contains(_searchQuery) ||
            p.bibNumber.toString().contains(_searchQuery)).toList()
          ..sort((a, b) => a.bibNumber.compareTo(b.bibNumber));

        if (filtered.isEmpty) {
          return const Center(child: Text("No Participants Match Search"));
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (ctx, index) => ParticipantTile(
            participant: filtered[index],
            onEdit: () => handleEditParticipant(filtered[index]),
            onDelete: () => handleDeleteParticipant(filtered[index]),
          ),
        );
    }
  }
}
