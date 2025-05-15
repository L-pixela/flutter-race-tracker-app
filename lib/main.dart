import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/data/firebase/firebase_checkpoint_repository.dart';

import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/data/firebase/firebase_race_repository.dart';
import 'package:race_tracker_project/data/repository/checkpoint_repository.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/data/repository/race_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/screens/manager_screen/race_screen.dart';
import 'package:race_tracker_project/screens/manager_screen/result_screen.dart';
import 'package:race_tracker_project/screens/provider/checkpoint_provider.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/provider/race_provider.dart';
import 'package:race_tracker_project/screens/provider/stopwatch_provider.dart';
import 'package:race_tracker_project/services/time_tracker_services.dart';
import 'package:race_tracker_project/theme/theme.dart';
import 'package:race_tracker_project/widgets/race_buttom_navigation.dart';

void main() async {
  // 1. Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Repository for Provider
  ParticipantRepository participantRepository = FirebaseParticipantRepository();
  RaceRepository raceRepository = FirebaseRaceRepository();
  CheckpointRepository checkpointRepository = FirebaseCheckpointRepository();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) =>
              ParticipantProvider(repository: participantRepository)),
      ChangeNotifierProvider(
          create: (context) => RaceProvider(repository: raceRepository)),
      ChangeNotifierProvider(create: (context) => StopwatchProvider()),
      ChangeNotifierProvider(
          create: (context) =>
              CheckpointProvider(repository: checkpointRepository)),
      ChangeNotifierProvider(
          create: (context) => TimeTrackerServices(
              checkpointRepository: checkpointRepository,
              participantProvider:
                  ParticipantProvider(repository: participantRepository)))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    RaceScreen(),
    ResultScreen(), 
    Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: raceAppTheme,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: RaceButtomNavigation(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
