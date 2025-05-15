import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/model/race/race.dart';

import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/services/race_services.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/race_action_bar.dart';

///
/// Race Screen for Race Manager to Start/Stop the race
///
class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to safely access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RaceProvider>().fetchRaceData();
    });
  }

  Color _getRaceStatusColor(Race race) {
    switch (race.raceStatus) {
      case RaceStatus.upcoming:
        return Colors.orange;
      case RaceStatus.ongoing:
        return Colors.green;
      case RaceStatus.completed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final raceProvider = context.watch<RaceProvider>();
    final raceService = RaceServices(raceProvider: raceProvider);

    final races = raceProvider.races.data;
    if (races == null || races.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final race = races.first;

    return Scaffold(
      backgroundColor: RaceColors.background,
      appBar: AppBar(
        title: Text("Race", style: RaceTextStyles.darkHeading),
        centerTitle: true,
        backgroundColor: RaceColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(RaceSpacings.l),
        child: Column(
          children: [
            Card(
              elevation: 3,
              color: RaceColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RaceSpacings.radius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(RaceSpacings.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      race.raceEvent,
                      style: RaceTextStyles.darkHeading.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Location: ${race.location.name}, Region: ${race.location.region.label}",
                      style: RaceTextStyles.darkHeading.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Status: ",
                          style:
                              RaceTextStyles.darkHeading.copyWith(fontSize: 12),
                        ),
                        Chip(
                          label: Text(
                            race.raceStatus.label,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white),
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          backgroundColor: _getRaceStatusColor(race),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: RaceSpacings.m),
            // Add Reset Button here
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // confirm before resetting
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Reset Race"),
                      content: const Text(
                          "Are you sure you want to reset the race?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    stopwatchProvider.reset(); // resets the timer
                    await raceService.resetRace(race);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.restart_alt),
                label: const Text("Reset Race"),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stopwatchProvider.timeDisplay,
                      style: RaceTextStyles.heading.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: RaceSpacings.xxl),
                ],
              ),
            ),
            RaceActionBar(race: race, raceServices: raceService)
          ],
        ),
      ),
    );
  }
}
