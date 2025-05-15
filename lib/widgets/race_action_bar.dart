import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/services/race_services.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

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
    final raceProvider = context.watch<RaceProvider>();

    final bool isRunningOrPaused =
        stopwatchProvider.isRunning || stopwatchProvider.isPaused;

    return Padding(
      padding: const EdgeInsets.only(bottom: RaceSpacings.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Start / Stop Button
          raceProvider.races.data!.first.raceStatus == RaceStatus.completed
              ? Button(
                  text: isRunningOrPaused ? "Stop" : "Start",
                  type: ButtonType.disabled,
                  width: 120,
                  height: 50,
                  onPressed: () {},
                )
              : Button(
                  text: isRunningOrPaused ? "Stop" : "Start",
                  type: ButtonType.primary,
                  width: 120,
                  height: 50,
                  onPressed: () async {
                    if (isRunningOrPaused) {
                      await raceServices.stopRace(race);
                      stopwatchProvider.stop();
                    } else {
                      await raceServices.startRace(race);
                      stopwatchProvider.start();
                    }
                  },
                ),

          // Pause / Resume Button
          Button(
            text: stopwatchProvider.isPaused ? "Resume" : "Pause",
            type: (!race.isCompleted() && isRunningOrPaused)
                ? ButtonType.secondary
                : ButtonType.disabled,
            width: 120,
            height: 50,
            onPressed: (!race.isCompleted() && isRunningOrPaused)
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
}
