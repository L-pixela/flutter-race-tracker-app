import 'package:flutter/material.dart';
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
                onPressed: () {},
                type: ButtonType.disabled,
                text: 'Share',
                width: 200,
                height: 50,
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {},
                type: ButtonType.disabled,
                text: 'Share',
                width: 200,
                height: 50,
              ),
              SizedBox(height: 20),
              Button(
                onPressed: () {},
                type: ButtonType.disabled,
                text: 'Share',
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
