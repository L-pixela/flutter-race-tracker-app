import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/services/race_services.dart';
import 'package:race_tracker_project/theme/theme.dart';

class RaceActionBar extends StatelessWidget {
  final Race race;
  final RaceServices raceServices;

  const RaceActionBar({
    super.key,
    required this.race,
    required this.raceServices,
  });

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = context.read<StopwatchProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: RaceSpacings.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left Button: Start/Stop
          _buildTextButton(
            stopwatchProvider.isRunning || stopwatchProvider.isPaused
                ? "Stop"
                : "Start",
            RaceColors.buttonPrimary,
            () async {
              if (stopwatchProvider.isRunning || stopwatchProvider.isPaused) {
                await raceServices.stopRace(race);
                stopwatchProvider.stop();
              } else {
                await raceServices.startRace(race);
                stopwatchProvider.start();
              }
            },
          ),

          // Right Button: Pause/Resume
          _buildTextButton(
            stopwatchProvider.isPaused ? "Resume" : "Pause",
            RaceColors.buttonSecondary,
            (!race.isCompleted() &&
                    (stopwatchProvider.isRunning || stopwatchProvider.isPaused))
                ? () {
                    if (stopwatchProvider.isPaused) {
                      stopwatchProvider.start(); // Resume
                    } else {
                      stopwatchProvider.pause(); // Pause
                    }
                  }
                : null,
          ),
        ],
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
