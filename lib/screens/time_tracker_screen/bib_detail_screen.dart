import 'package:flutter/material.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/track_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BibDetailScreen(bibNumber: 1),
    );
  }
}

///////
class BibDetailScreen extends StatelessWidget {
  final int bibNumber;

  const BibDetailScreen({super.key, required this.bibNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RaceColors.primary,
        iconTheme: IconThemeData(color: RaceColors.white),
        title: Text(
          'BIB $bibNumber',
          style: RaceTextStyles.heading.copyWith(color: RaceColors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink to fit children
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'BIB $bibNumber',
                style:
                    RaceTextStyles.heading.copyWith(color: RaceColors.primary),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                    width: 90,
                    height: 60,
                    text: 'Back',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackScreen(raceId: 'R1', segment: ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Button(
                    width: 90,
                    height: 60,
                    text: 'Reset',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
