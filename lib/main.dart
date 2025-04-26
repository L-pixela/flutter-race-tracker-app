import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker_project/data/firebase/firebase_participant_repository.dart';
import 'package:race_tracker_project/data/repository/participant_repository.dart';
import 'package:race_tracker_project/firebase_options.dart';
import 'package:race_tracker_project/screens/manager_screen/dashboard_screen.dart';
import 'package:race_tracker_project/screens/provider/participant_provider.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/segment_selection_screen.dart';
import 'package:race_tracker_project/screens/time_tracker_screen/track_screen.dart';
import 'package:race_tracker_project/theme/theme.dart';

void main() async {
  // 1. Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Repository for Provider
  ParticipantRepository participantRepository = FirebaseParticipantRepository();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) =>
              ParticipantProvider(repository: participantRepository)),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: raceAppTheme,
      home: Scaffold(body: SegmentSelectionScreen()),

      // RegisterForm(selectedGender: '',)

      // body: Column(

      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     /// test the race button
      //     // Center(
      //     //   child: RaceButton(
      //     //     text: '09002',
      //     //     onPressed: () => print('Button clicked!'),
      //     //     width: 100,
      //     //   ),
      //     // ),

      //     Image.asset("assets/images/triathlon-yellow.gif")
      //     // AddUser("John Doe", "Acme Inc.", 30),
      //     // SizedBox(
      //     //   height: 15,
      //     // ),
      //     // GetUserByName(full_name),
      //     // SizedBox(
      //     //   height: 15,
      //     // ),
      //     // UpdateUserByName(full_name),
      //     // SizedBox(
      //     //   height: 15,
      //     // ),
      //     // DeleteUserByName(full_name),
      //   ],
      // )
    );
  }
}
