import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/services/race_services.dart';
import 'package:race_tracker_project/theme/theme.dart';

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
      final raceProvider = context.read<RaceProvider>();
      raceProvider.fetchRaceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    final raceProvider = context.read<RaceProvider>();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
            );
          },
        ),
        title: Text("Race", style: RaceTextStyles.darkHeading),
        centerTitle: true,
        backgroundColor: RaceColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(RaceSpacings.l),
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.only(bottom: RaceSpacings.l),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stopwatchProvider.isRunning || stopwatchProvider.isPaused
                      ? _buildTextButton(
                          "Save",
                          RaceColors.buttonPrimary,
                          () async {
                            await raceService.stopRace(race); // Save endDate
                            stopwatchProvider.reset();
                          },
                        )
                      : _buildTextButton("Start", RaceColors.buttonPrimary,
                          () async {
                          await raceService.startRace(race);
                          stopwatchProvider.start();
                        }),
                  _buildTextButton(
                    "Pause",
                    RaceColors.buttonSecondary,
                    stopwatchProvider.isRunning
                        ? stopwatchProvider.pause
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, Color color, VoidCallback? onPressed) {
    return SizedBox(
      width: 120,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(
            vertical: RaceSpacings.m,
            horizontal: RaceSpacings.l,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RaceSpacings.m),
          ),
        ),
        child: Text(text, style: RaceTextStyles.button),
      ),
    );
  }
}
