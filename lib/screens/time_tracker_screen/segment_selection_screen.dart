import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/track_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';

class SegmentSelectionScreen extends StatelessWidget {
  const SegmentSelectionScreen({super.key});

  Color _getRaceStatusColor(Race race) {
    switch (race.raceStatus) {
      case RaceStatus.upcoming:
        return Colors.orange;
      case RaceStatus.ongoing:
        return Colors.green;
      case RaceStatus.completed:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final race = context.watch<RaceProvider>().races.data?.first;
    final stopwatchProvider = context.watch<StopwatchProvider>();

    if (race == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: RaceColors.primary,
          iconTheme: IconThemeData(color: RaceColors.white),
          flexibleSpace: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Time Tracker',
                      style: RaceTextStyles.heading
                          .copyWith(color: RaceColors.white)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Status: ",
                          style: RaceTextStyles.darkHeading
                              .copyWith(fontSize: 12)),
                      Chip(
                        label: Text(
                          race.raceStatus.label,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        backgroundColor: _getRaceStatusColor(race),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                  ),
                  Text(
                    stopwatchProvider.timeDisplay,
                    style: RaceTextStyles.heading.copyWith(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select a Segment',
                  style: RaceTextStyles.heading.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 20),
                // Swimming Button
                Button(
                  onPressed: race.raceStatus == RaceStatus.ongoing
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackScreen(
                                      segment: 'Swimming',
                                    )),
                          );
                        }
                      : null,
                  type: race.raceStatus == RaceStatus.ongoing
                      ? ButtonType.primary
                      : ButtonType.disabled,
                  text: 'Swimming',
                  width: 200,
                  height: 50,
                ),
                const SizedBox(height: 20),
                // Running Button
                Button(
                  onPressed: race.raceStatus == RaceStatus.ongoing
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackScreen(
                                      segment: 'Running',
                                    )),
                          );
                        }
                      : null,
                  type: race.raceStatus == RaceStatus.ongoing
                      ? ButtonType.primary
                      : ButtonType.disabled,
                  text: 'Running',
                  width: 200,
                  height: 50,
                ),
                const SizedBox(height: 20),
                // Cycling Button
                Button(
                  onPressed: race.raceStatus == RaceStatus.ongoing
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackScreen(
                                      segment: 'Cycling',
                                    )),
                          );
                        }
                      : null,
                  type: race.raceStatus == RaceStatus.ongoing
                      ? ButtonType.primary
                      : ButtonType.disabled,
                  text: 'Cycling',
                  width: 200,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
