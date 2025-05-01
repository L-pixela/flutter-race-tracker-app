import 'package:flutter/material.dart';
import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';

class RaceNavigation extends StatefulWidget {
  const RaceNavigation({super.key});

  @override
  State<RaceNavigation> createState() => _RaceNavigationState();
}

class _RaceNavigationState extends State<RaceNavigation> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: RaceColors.white,
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
                selectedIcon: Icon(Icons.dashboard),
                icon: Icon(Icons.dashboard_outlined),
                label: "Dashboard"),
            NavigationDestination(icon: Icon(Icons.rocket), label: "Race"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
          ]),
    );
  }
}
