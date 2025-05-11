import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/model/race/race.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/track_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Select a Segment',
                style: RaceTextStyles.heading.copyWith(fontSize: 24),
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {
                  // Navigate to TrackScreen when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackScreen(
                        raceId: "R1",
                        segment: RaceSegment.swimming,
                      ),
                    ),
                  );
                },
                type: ButtonType.primary,
                text: RaceSegment.swimming.label,
                width: 200,
                height: 50,
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {
                  // Navigate to TrackScreen when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackScreen(
                        raceId: "R1",
                        segment: RaceSegment.cycling,
                      ),
                    ),
                  );
                },
                type: ButtonType.primary,
                text: RaceSegment.cycling.label,
                width: 200,
                height: 50,
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {
                  // Navigate to TrackScreen when pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackScreen(
                        raceId: "R1",
                        segment: RaceSegment.running,
                      ),
                    ),
                  );
                },
                type: ButtonType.primary,
                text: RaceSegment.running.label,
                width: 200,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
