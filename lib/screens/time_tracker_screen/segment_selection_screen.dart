import 'package:flutter/material.dart';
import 'package:race_tracker_project/model/race_segment/race_segment.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/track_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

class SegmentSelectionScreen extends StatelessWidget {
  const SegmentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Time Tracker',
                    style: RaceTextStyles.heading
                        .copyWith(color: RaceColors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: In Progress',
                    style: RaceTextStyles.body.copyWith(
                      color: RaceColors.white,
                    ),
                  ),
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
                style: TextStyle(fontSize: 24),
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
