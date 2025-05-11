import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker_project/services/time_tracker_services.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/app_button.dart';

///////
class BibDetailScreen extends StatelessWidget {
  final int bibNumber;

  const BibDetailScreen({super.key, required this.bibNumber});

  @override
  Widget build(BuildContext context) {
    final timeTrackerServices = context.read<TimeTrackerServices>();
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
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Button(
                    width: 90,
                    height: 60,
                    text: 'Reset',
                    onPressed: () {
                      timeTrackerServices.undoLastTap(bibNumber);
                    },
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
