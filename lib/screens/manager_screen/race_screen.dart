import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/navigation_bar.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);

    return Scaffold(
      bottomNavigationBar: Navigation_Bar(initialIndex: 1),
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
                          "Reset",
                          RaceColors.buttonPrimary,
                          stopwatchProvider.reset,
                        )
                      : _buildTextButton(
                          "Start",
                          RaceColors.buttonPrimary,
                          stopwatchProvider.start,
                        ),
                  _buildTextButton(
                    "Pause",
                    RaceColors.buttonSecondary,
                    stopwatchProvider.isRunning ? stopwatchProvider.pause : null,
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
